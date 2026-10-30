// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * The per-neighbour tables of the adaptive arms, free of simulator types so
 * the module's test suite checks the arithmetic directly (time is seconds as a
 * double, addresses an opaque key).
 *
 * PheromoneTable keeps tau(dest, neighbour) with LAZY decay: each entry stores
 * its value and the time it was last brought up to date, and every read
 * applies the decay for the elapsed time first. That is exactly the
 * continuous decay Termite specifies (P <- P e^{-(t - t_last) tau}) and,
 * for ARA's periodic evaporation phi <- (1 - q) phi (eq. 2), the same
 * geometric decay evaluated at fractional periods, which removes the
 * per-period timer and its phase as an arbitrary choice. An entry that decays
 * below the floor is removed: the route has evaporated.
 */
#ifndef ADAPTIVE_TABLES_H
#define ADAPTIVE_TABLES_H

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <map>
#include <set>
#include <utility>
#include <vector>

namespace ns3 {
namespace adaptive {

template <typename Addr>
class PheromoneTable {
public:
    enum class Decay {
        Geometric,    ///< v * (1 - rate)^(dt / period)   (ARA eq. 2)
        Exponential,  ///< v * e^(-rate * dt)              (Termite)
    };

    void Configure(Decay decay, double rate, double period, double floor) {
        m_decay = decay;
        m_rate = rate;
        m_period = period;
        m_floor = floor;
    }

    /// The decayed value, 0 when absent or evaporated.
    double Get(const Addr& dst, const Addr& nb, double now) {
        Entry* e = Find(dst, nb);
        if (!e) {
            return 0.0;
        }
        Refresh(*e, now);
        return e->value;
    }

    void Add(const Addr& dst, const Addr& nb, double delta, double now) {
        Entry& e = m_table[dst][nb];
        Refresh(e, now);
        e.value += delta;
        e.last = now;
    }

    /// Raise to at least `value` (a discovery ant never lowers a trail).
    void SetAtLeast(const Addr& dst, const Addr& nb, double value, double now) {
        Entry& e = m_table[dst][nb];
        Refresh(e, now);
        if (e.value < value) {
            e.value = value;
        }
        e.last = now;
    }

    void Erase(const Addr& dst, const Addr& nb) {
        auto d = m_table.find(dst);
        if (d == m_table.end()) {
            return;
        }
        d->second.erase(nb);
        if (d->second.empty()) {
            m_table.erase(d);
        }
    }

    void EraseNeighbor(const Addr& nb) {
        for (auto d = m_table.begin(); d != m_table.end();) {
            d->second.erase(nb);
            d = d->second.empty() ? m_table.erase(d) : std::next(d);
        }
    }

    /// The live (neighbour, value) pairs for `dst`; evaporated ones are pruned.
    std::vector<std::pair<Addr, double>> Entries(const Addr& dst, double now) {
        std::vector<std::pair<Addr, double>> out;
        auto d = m_table.find(dst);
        if (d == m_table.end()) {
            return out;
        }
        for (auto it = d->second.begin(); it != d->second.end();) {
            Refresh(it->second, now);
            if (it->second.value < m_floor) {
                it = d->second.erase(it);
                continue;
            }
            out.emplace_back(it->first, it->second.value);
            ++it;
        }
        if (d->second.empty()) {
            m_table.erase(d);
        }
        return out;
    }

    bool HasRoute(const Addr& dst, double now) { return !Entries(dst, now).empty(); }

    std::set<Addr> Neighbors() const {
        std::set<Addr> out;
        for (const auto& d : m_table) {
            for (const auto& n : d.second) {
                out.insert(n.first);
            }
        }
        return out;
    }

    /// Drop every evaporated entry (keeps the table bounded by live trails).
    void Prune(double now) {
        std::vector<Addr> dsts;
        for (const auto& d : m_table) {
            dsts.push_back(d.first);
        }
        for (const auto& d : dsts) {
            Entries(d, now);
        }
    }

    std::size_t Size() const {
        std::size_t n = 0;
        for (const auto& d : m_table) {
            n += d.second.size();
        }
        return n;
    }

private:
    struct Entry {
        double value = 0.0;
        double last = 0.0;
    };

    Entry* Find(const Addr& dst, const Addr& nb) {
        auto d = m_table.find(dst);
        if (d == m_table.end()) {
            return nullptr;
        }
        auto n = d->second.find(nb);
        return n == d->second.end() ? nullptr : &n->second;
    }

    void Refresh(Entry& e, double now) const {
        const double dt = now - e.last;
        if (dt > 0.0 && e.value > 0.0) {
            e.value *= m_decay == Decay::Geometric ? std::pow(1.0 - m_rate, dt / m_period)
                                                   : std::exp(-m_rate * dt);
        }
        e.last = now;
    }

    std::map<Addr, std::map<Addr, Entry>> m_table;
    Decay m_decay = Decay::Geometric;
    double m_rate = 0.1;
    double m_period = 1.0;
    double m_floor = 1e-3;
};

/**
 * Termite's pheromone table (Roth 2005, §4.2): one row per neighbour, one
 * column per known destination, every cell bounded to [floor, ceiling].
 *
 * Unlike PheromoneTable nothing expires: decay stops at the floor, which
 * marks a cell as unused. A new destination's column and a new neighbour's
 * row start every cell at the initial pheromone (§4.2.4). A destination is
 * forgotten when its whole column has decayed to the floor, a neighbour when
 * its whole row has (§4.2.3), or at once when the link is lost.
 */
template <typename Addr>
class BoundedPheromoneTable {
public:
    void Configure(double rate, double initial, double floor, double ceiling) {
        m_rate = rate;
        m_initial = initial;
        m_floor = floor;
        m_ceiling = ceiling;
    }

    bool HasNeighbor(const Addr& nb) const { return m_neighbors.count(nb) > 0; }
    bool HasDestination(const Addr& d) const { return m_cells.count(d) > 0; }
    const std::set<Addr>& Neighbors() const { return m_neighbors; }
    double Floor() const { return m_floor; }

    /// Add a neighbour row, every known destination at the initial value.
    void AddNeighbor(const Addr& nb, double now) {
        if (!m_neighbors.insert(nb).second) {
            return;
        }
        for (auto& d : m_cells) {
            d.second[nb] = Cell{m_initial, now};
        }
    }

    /// Add a destination column, every neighbour at the initial value.
    void AddDestination(const Addr& d, double now) {
        if (m_cells.count(d)) {
            return;
        }
        auto& col = m_cells[d];
        for (const Addr& nb : m_neighbors) {
            col[nb] = Cell{m_initial, now};
        }
    }

    /// P(nb, d) += delta, creating the row and column first if needed.
    void Deposit(const Addr& d, const Addr& nb, double delta, double now) {
        AddNeighbor(nb, now);
        AddDestination(d, now);
        Cell& c = m_cells[d][nb];
        Refresh(c, now);
        c.value = std::min(m_ceiling, c.value + delta);
    }

    double Get(const Addr& d, const Addr& nb, double now) {
        auto col = m_cells.find(d);
        if (col == m_cells.end()) {
            return 0.0;
        }
        auto it = col->second.find(nb);
        if (it == col->second.end()) {
            return 0.0;
        }
        Refresh(it->second, now);
        return it->second.value;
    }

    void RemoveNeighbor(const Addr& nb) {
        m_neighbors.erase(nb);
        for (auto& d : m_cells) {
            d.second.erase(nb);
        }
    }

    /// Forget decayed destinations and neighbours (§4.2.3). Returns the
    /// neighbours removed.
    std::vector<Addr> Prune(double now) {
        std::vector<Addr> gone;
        for (auto d = m_cells.begin(); d != m_cells.end();) {
            bool live = false;
            for (auto& c : d->second) {
                Refresh(c.second, now);
                live = live || c.second.value > m_floor;
            }
            // A neighbour's own column stays while its row is in use.
            d = (live || m_neighbors.count(d->first)) ? std::next(d) : m_cells.erase(d);
        }
        for (const Addr& nb : std::vector<Addr>(m_neighbors.begin(), m_neighbors.end())) {
            bool live = false;
            for (auto& d : m_cells) {
                auto it = d.second.find(nb);
                live = live || (it != d.second.end() && it->second.value > m_floor);
            }
            if (!live) {
                RemoveNeighbor(nb);
                gone.push_back(nb);
            }
        }
        return gone;
    }

private:
    struct Cell {
        double value = 0.0;
        double last = 0.0;
    };

    void Refresh(Cell& c, double now) const {
        const double dt = now - c.last;
        if (dt > 0.0) {
            c.value = std::max(m_floor, c.value * std::exp(-m_rate * dt));
        }
        c.last = now;
    }

    std::map<Addr, std::map<Addr, Cell>> m_cells;  // destination -> neighbour -> cell
    std::set<Addr> m_neighbors;
    double m_rate = 0.105;
    double m_initial = 1.0;
    double m_floor = 0.1;
    double m_ceiling = 10000.0;
};

/**
 * Draw one candidate with probability proportional to its weight, from a
 * uniform `u` in [0, 1). Returns the index, or -1 when every weight is zero.
 */
inline int PickProportional(const std::vector<double>& weights, double u) {
    double sum = 0.0;
    for (double w : weights) {
        sum += w;
    }
    if (sum <= 0.0) {
        return -1;
    }
    double acc = 0.0;
    const double target = u * sum;
    for (std::size_t i = 0; i < weights.size(); ++i) {
        acc += weights[i];
        if (target < acc) {
            return static_cast<int>(i);
        }
    }
    // u -> 1 with rounding: the last positive weight.
    for (std::size_t i = weights.size(); i-- > 0;) {
        if (weights[i] > 0.0) {
            return static_cast<int>(i);
        }
    }
    return -1;
}

/// Termite's forwarding weight (P + K)^F (Roth, the forwarding equation).
inline double TermiteWeight(double pheromone, double k, double f) {
    return std::pow(pheromone + k, f);
}

/**
 * Boyan & Littman's Q-routing update (NIPS 1993, eq. 1):
 * Q_x(d, y) <- Q_x(d, y) + eta (q + s + t - Q_x(d, y)), with q the time the
 * packet waited at x, s the transmission time and t = min_z Q_y(d, z) the
 * estimate the neighbour y sends back.
 */
inline double QUpdate(double q, double eta, double queueWait, double txTime,
                      double neighborEstimate) {
    return q + eta * (queueWait + txTime + neighborEstimate - q);
}

/**
 * BeeAdHoc's route rating (PG 460 report, Listing 13.15 "forager rate
 * lifetime"): how many extra packets a forager may recruit while it dances.
 * `hops` is the route length in links; `levels` holds the 3-bit value (0..7)
 * each intermediate node wrote (the report's 24-bit info field, one value per
 * hop). A direct neighbour gets the maximum; otherwise
 * ((maxHops - (hops - 1)) * min * avg + 1) / 44 in integer arithmetic, as the
 * listing computes it. The listing does not cap the result; it is capped at
 * maxDances here so a two-hop route never outranks a direct neighbour.
 */
inline uint32_t BeeDances(uint32_t hops, const std::vector<uint8_t>& levels, uint32_t maxHops,
                          uint32_t maxDances) {
    if (hops < 2) {
        return maxDances;
    }
    if (hops - 1 > maxHops) {
        return 0;
    }
    uint32_t mn = 7;
    uint32_t sum = 0;
    for (uint8_t v : levels) {
        mn = std::min<uint32_t>(mn, v & 7u);
        sum += v & 7u;
    }
    const uint32_t avg = levels.empty() ? 7u : sum / static_cast<uint32_t>(levels.size());
    const uint32_t v = ((maxHops - (hops - 1)) * mn * avg + 1) / 44;
    return std::min(v, maxDances);
}

/**
 * BeeAdHoc's forager store (PG 460, Listings 13.16, 13.17 and 13.29): per
 * destination, an array of the node's 'own' foragers (routes it discovered or
 * that came back to it) and one of 'foreign' foragers (routes back to a node
 * that sent it data). Each forager is a full source route plus the per-hop
 * values its rating came from.
 *
 * Take() follows get_opt_forager: a forager drawn uniformly at random that is
 * still dancing (dances left, younger than the dance time) is copied and its
 * dances decremented; otherwise it leaves the array, and one older than the
 * lifetime is discarded unless it is the last forager for that destination.
 * 'Own' foragers are used first, 'foreign' ones only when none are left
 * (§13.7.1).
 */
template <typename Addr>
class ForagerStore {
public:
    struct Forager {
        std::vector<Addr> path;       ///< source .. destination
        std::vector<uint8_t> levels;  ///< one 3-bit value per intermediate node
        uint32_t dances = 0;
        double stamp = 0.0;
    };

    void Configure(uint32_t arraySize, double lifetime, double danceTime, uint32_t maxHops,
                   uint32_t maxDances) {
        m_arraySize = arraySize;
        m_lifetime = lifetime;
        m_danceTime = danceTime;
        m_maxHops = maxHops;
        m_maxDances = maxDances;
    }

    /// insert_forager_into_array: false (forager discarded) when the array is full.
    bool Put(const Addr& dst, Forager f, bool foreign, double now) {
        std::vector<Forager>& list = foreign ? m_entries[dst].foreign : m_entries[dst].own;
        if (list.size() >= m_arraySize || f.path.size() < 2) {
            return false;
        }
        f.dances =
            BeeDances(static_cast<uint32_t>(f.path.size() - 1), f.levels, m_maxHops, m_maxDances);
        f.stamp = now;
        list.push_back(std::move(f));
        return true;
    }

    /// A forager for `dst`, or false when none is left. `pick(n)` draws
    /// uniformly from [0, n).
    template <typename Pick>
    bool Take(const Addr& dst, double now, Pick pick, Forager& out) {
        auto it = m_entries.find(dst);
        if (it == m_entries.end()) {
            return false;
        }
        for (std::vector<Forager>* list : {&it->second.own, &it->second.foreign}) {
            while (!list->empty()) {
                const uint32_t i = pick(static_cast<uint32_t>(list->size()));
                Forager& f = (*list)[i];
                const double age = now - f.stamp;
                if (f.dances > 0 && age < m_danceTime) {
                    --f.dances;
                    out = f;
                    return true;
                }
                Forager taken = std::move(f);
                if (i + 1 != list->size()) {
                    (*list)[i] = std::move(list->back());
                }
                list->pop_back();
                const bool last = it->second.own.empty() && it->second.foreign.empty();
                if (age < m_lifetime || last) {
                    out = std::move(taken);
                    return true;
                }
            }
        }
        return false;
    }

    /// Up to `n` foreign foragers for `dst`, removed (a swarm's cargo).
    std::vector<Forager> TakeForeign(const Addr& dst, uint32_t n) {
        std::vector<Forager> out;
        auto it = m_entries.find(dst);
        if (it == m_entries.end()) {
            return out;
        }
        std::vector<Forager>& list = it->second.foreign;
        while (!list.empty() && out.size() < n) {
            out.push_back(std::move(list.back()));
            list.pop_back();
        }
        return out;
    }

    uint32_t Count(const Addr& dst, bool foreign) const {
        auto it = m_entries.find(dst);
        if (it == m_entries.end()) {
            return 0;
        }
        return static_cast<uint32_t>(foreign ? it->second.foreign.size() : it->second.own.size());
    }

    /// Drop every forager whose route uses the link a -> b.
    void RemoveLink(const Addr& a, const Addr& b) {
        for (auto& kv : m_entries) {
            for (std::vector<Forager>* list : {&kv.second.own, &kv.second.foreign}) {
                list->erase(std::remove_if(list->begin(), list->end(),
                                           [&](const Forager& f) {
                                               for (size_t k = 0; k + 1 < f.path.size(); ++k) {
                                                   if (f.path[k] == a && f.path[k + 1] == b) {
                                                       return true;
                                                   }
                                               }
                                               return false;
                                           }),
                            list->end());
            }
        }
    }

    /// The first hop of every stored route (the arm's known neighbours).
    std::set<Addr> FirstHops() const {
        std::set<Addr> out;
        for (const auto& kv : m_entries) {
            for (const std::vector<Forager>* list : {&kv.second.own, &kv.second.foreign}) {
                for (const Forager& f : *list) {
                    out.insert(f.path[1]);
                }
            }
        }
        return out;
    }

private:
    struct Entry {
        std::vector<Forager> own;
        std::vector<Forager> foreign;
    };
    std::map<Addr, Entry> m_entries;
    uint32_t m_arraySize = 64;
    double m_lifetime = 2.0;
    double m_danceTime = 2.0;
    uint32_t m_maxHops = 10;
    uint32_t m_maxDances = 8;
};

}  // namespace adaptive
}  // namespace ns3

#endif  // ADAPTIVE_TABLES_H
