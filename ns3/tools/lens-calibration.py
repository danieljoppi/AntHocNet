#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""
lens-calibration.py PING_TXT...

Summarise LENS Starlink ping traces (Zhao & Pan, MMSys 2024; dataset at
https://lens-starlink.jinwei.me, CC BY-SA 4.0) into the numbers the
moving-constellation page calibrates against (#297 item 5):

  * RTT distribution dish -> PoP (min, p5, p50, p95, p99) and packet loss;
  * the 15 s reconfiguration signature: loss rate and median RTT per second
    of the 15 s cycle (UTC second mod 15). leo-walker's handover clock fires
    at second 12 of every 15 s (the WWW 2024 measurement); if that clock is
    right, the measured loss should peak at phase 12.

Input is the raw `ping -D` text the LENS archives contain (one file per hour:
"[epoch] 64 bytes from ...: icmp_seq=N ttl=.. time=X ms" and "[epoch] no
answer yet for icmp_seq=N"). A sequence number counts as lost if it never
gets a reply line. Stdlib only; the traces themselves are not committed (a
day is ~800 MB uncompressed) -- the page records which ones were used.
"""
import re
import statistics
import sys

SUMMARY = re.compile(r"^(\d+) packets transmitted, (\d+) received")
REPLY = re.compile(r"^\[(\d+\.\d+)\] \d+ bytes from .*icmp_seq=(\d+) .*time=([\d.]+) ms")
NOANS = re.compile(r"^\[(\d+\.\d+)\] no answer yet for icmp_seq=(\d+)")


def quantile(xs, q):
    k = (len(xs) - 1) * q
    lo = int(k)
    hi = min(lo + 1, len(xs) - 1)
    return xs[lo] + (xs[hi] - xs[lo]) * (k - lo)


def unwrap(seq, last):
    """icmp_seq is 16-bit and wraps (an hour of 10 ms pings is ~245k): pick
    the absolute sequence number nearest the last one seen."""
    if last is None:
        return seq
    base = last - (last % 65536)
    cands = (base - 65536 + seq, base + seq, base + 65536 + seq)
    return min(cands, key=lambda c: abs(c - last))


def main(paths):
    rtts = []
    phase_rtt = [[] for _ in range(15)]
    phase_sent = [0] * 15
    phase_lost = [0] * 15
    sent = lost = 0
    tx_summary = rx_summary = 0
    for path in paths:
        first = {}   # absolute seq -> send-time estimate (first time we saw it)
        replied = set()
        last = None
        with open(path, errors="replace") as fh:
            for line in fh:
                m = SUMMARY.match(line)
                if m:
                    tx_summary += int(m.group(1))
                    rx_summary += int(m.group(2))
                    continue
                m = REPLY.match(line)
                if m:
                    t, rtt = float(m.group(1)), float(m.group(3))
                    seq = last = unwrap(int(m.group(2)), last)
                    if seq in replied:
                        continue  # duplicate
                    replied.add(seq)
                    send = t - rtt / 1000.0
                    first[seq] = min(first.get(seq, send), send)
                    rtts.append(rtt)
                    phase_rtt[int(send) % 15].append(rtt)
                    continue
                m = NOANS.match(line)
                if m:
                    seq = last = unwrap(int(m.group(2)), last)
                    first.setdefault(seq, float(m.group(1)))
        for seq, t in first.items():
            ph = int(t) % 15
            phase_sent[ph] += 1
            sent += 1
            if seq not in replied:
                phase_lost[ph] += 1
                lost += 1
    rtts.sort()
    print(f"files {len(paths)}  pings {sent}  replies {len(rtts)}  "
          f"loss {100.0 * lost / sent:.3f} %  (ping's own summaries: "
          f"{tx_summary} sent, {100.0 * (tx_summary - rx_summary) / tx_summary:.3f} % loss)")
    print(f"RTT ms  min {rtts[0]:.1f}  p5 {quantile(rtts, 0.05):.1f}  "
          f"p50 {quantile(rtts, 0.5):.1f}  p95 {quantile(rtts, 0.95):.1f}  "
          f"p99 {quantile(rtts, 0.99):.1f}")
    print("phase (UTC s mod 15) | loss % | median RTT ms")
    for ph in range(15):
        loss = 100.0 * phase_lost[ph] / phase_sent[ph] if phase_sent[ph] else 0.0
        med = statistics.median(phase_rtt[ph]) if phase_rtt[ph] else float("nan")
        print(f"{ph:2d} | {loss:6.3f} | {med:6.1f}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    main(sys.argv[1:])
