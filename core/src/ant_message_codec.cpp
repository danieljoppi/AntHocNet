#include "anthocnet/core/ant_message_codec.h"

#include <cstring>

namespace anthocnet {
namespace core {
namespace codec {

namespace {

// Little-endian primitive writers/readers. Kept explicit (rather than a raw
// struct memcpy) so the format is portable across compilers/endianness and
// stable between the two adapters.

void putU8(std::vector<std::uint8_t>& b, std::uint8_t v) { b.push_back(v); }

void putU16(std::vector<std::uint8_t>& b, std::uint16_t v) {
    b.push_back(static_cast<std::uint8_t>(v & 0xFF));
    b.push_back(static_cast<std::uint8_t>((v >> 8) & 0xFF));
}

void putU32(std::vector<std::uint8_t>& b, std::uint32_t v) {
    for (int i = 0; i < 4; ++i) b.push_back(static_cast<std::uint8_t>((v >> (8 * i)) & 0xFF));
}

void putI32(std::vector<std::uint8_t>& b, std::int32_t v) {
    putU32(b, static_cast<std::uint32_t>(v));
}

void putDouble(std::vector<std::uint8_t>& b, double v) {
    std::uint64_t bits;
    std::memcpy(&bits, &v, sizeof(bits));
    for (int i = 0; i < 8; ++i) b.push_back(static_cast<std::uint8_t>((bits >> (8 * i)) & 0xFF));
}

struct Reader {
    const std::uint8_t* p;
    std::size_t remaining;
    bool ok = true;

    bool need(std::size_t n) {
        if (remaining < n) { ok = false; return false; }
        return true;
    }
    std::uint8_t u8() {
        if (!need(1)) return 0;
        std::uint8_t v = *p++; --remaining; return v;
    }
    std::uint16_t u16() {
        if (!need(2)) return 0;
        std::uint16_t v = static_cast<std::uint16_t>(p[0]) |
                          (static_cast<std::uint16_t>(p[1]) << 8);
        p += 2; remaining -= 2; return v;
    }
    std::uint32_t u32() {
        if (!need(4)) return 0;
        std::uint32_t v = 0;
        for (int i = 0; i < 4; ++i) v |= static_cast<std::uint32_t>(p[i]) << (8 * i);
        p += 4; remaining -= 4; return v;
    }
    std::int32_t i32() { return static_cast<std::int32_t>(u32()); }
    double dbl() {
        if (!need(8)) return 0.0;
        std::uint64_t bits = 0;
        for (int i = 0; i < 8; ++i) bits |= static_cast<std::uint64_t>(p[i]) << (8 * i);
        p += 8; remaining -= 8;
        double v;
        std::memcpy(&v, &bits, sizeof(v));
        return v;
    }
};

constexpr std::size_t kVersionSize = 1;      // offset-0 wire-version byte
constexpr std::size_t kHopSize     = 4 + 8;  // int32 node + double time
constexpr std::size_t kHelloSize   = 4 + 8;  // int32 node + double pheromone
constexpr std::size_t kFixedSize   = 1 + 1 + 4 + 4 + 4 + 8 + 8 + 4 + 4 + 8 + 8;
constexpr std::size_t kCountFields = 2 + 2 + 2;  // visited, history, hello counts

bool validType(std::uint8_t v) {
    return v == static_cast<std::uint8_t>(AntType::Hello) ||
           v == static_cast<std::uint8_t>(AntType::Reactive) ||
           v == static_cast<std::uint8_t>(AntType::Proactive) ||
           v == static_cast<std::uint8_t>(AntType::Repair);
}

bool validDirection(std::uint8_t v) {
    return v == static_cast<std::uint8_t>(AntDirection::Up) ||
           v == static_cast<std::uint8_t>(AntDirection::Down);
}

} // namespace

std::size_t serializedSize(const AntMessage& msg) {
    return kVersionSize + kFixedSize + kCountFields +
           msg.visited.size() * kHopSize +
           msg.history.size() * kHopSize +
           msg.helloDests.size() * kHelloSize;
}

void serialize(const AntMessage& msg, std::vector<std::uint8_t>& out) {
    out.clear();
    out.reserve(serializedSize(msg));

    putU8(out, kWireVersion);
    putU8(out, static_cast<std::uint8_t>(msg.type));
    putU8(out, static_cast<std::uint8_t>(msg.direction));
    putI32(out, msg.src);
    putI32(out, msg.dst);
    putU32(out, msg.seqNum);
    putDouble(out, msg.timeStart);
    putDouble(out, msg.lifeAnt);
    putI32(out, msg.prevHop);
    putI32(out, static_cast<std::int32_t>(msg.hops));
    putDouble(out, msg.prevSINR);
    putDouble(out, msg.pheromone);

    putU16(out, static_cast<std::uint16_t>(msg.visited.size()));
    for (const AntHop& h : msg.visited) { putI32(out, h.node); putDouble(out, h.time); }
    putU16(out, static_cast<std::uint16_t>(msg.history.size()));
    for (const AntHop& h : msg.history) { putI32(out, h.node); putDouble(out, h.time); }
    putU16(out, static_cast<std::uint16_t>(msg.helloDests.size()));
    for (const HelloDest& d : msg.helloDests) { putI32(out, d.node); putDouble(out, d.pheromone); }
}

std::vector<std::uint8_t> serialize(const AntMessage& msg) {
    std::vector<std::uint8_t> out;
    serialize(msg, out);
    return out;
}

bool deserialize(const std::uint8_t* bytes, std::size_t len, AntMessage& msg) {
    Reader r;
    r.p = bytes;
    r.remaining = len;

    // Trust boundary: reject foreign/stale frames and invalid enums in O(1)
    // before touching any length-prefixed section.
    if (r.u8() != kWireVersion) return false;
    const std::uint8_t typeByte = r.u8();
    const std::uint8_t dirByte  = r.u8();
    if (!r.ok || !validType(typeByte) || !validDirection(dirByte)) return false;
    msg.type      = static_cast<AntType>(typeByte);
    msg.direction = static_cast<AntDirection>(dirByte);
    msg.src       = r.i32();
    msg.dst       = r.i32();
    msg.seqNum    = r.u32();
    msg.timeStart = r.dbl();
    msg.lifeAnt   = r.dbl();
    msg.prevHop   = r.i32();
    msg.hops      = static_cast<int>(r.i32());
    msg.prevSINR  = r.dbl();
    msg.pheromone = r.dbl();

    const std::uint16_t nVisited = r.u16();
    if (!r.ok || nVisited > kMaxVisitedOnWire ||
        r.remaining < static_cast<std::size_t>(nVisited) * kHopSize) return false;
    msg.visited.resize(nVisited);
    for (auto& h : msg.visited) { h.node = r.i32(); h.time = r.dbl(); }

    const std::uint16_t nHistory = r.u16();
    if (!r.ok || nHistory > kMaxHistoryOnWire ||
        r.remaining < static_cast<std::size_t>(nHistory) * kHopSize) return false;
    msg.history.resize(nHistory);
    for (auto& h : msg.history) { h.node = r.i32(); h.time = r.dbl(); }

    const std::uint16_t nHello = r.u16();
    if (!r.ok || nHello > kMaxHelloOnWire ||
        r.remaining < static_cast<std::size_t>(nHello) * kHelloSize) return false;
    msg.helloDests.resize(nHello);
    for (auto& d : msg.helloDests) { d.node = r.i32(); d.pheromone = r.dbl(); }

    return r.ok;
}

} // namespace codec
} // namespace core
} // namespace anthocnet
