/**
 * Canonical, simulator-agnostic wire format for an AntMessage.
 *
 * Both adapters reuse this so an NS-2 and an NS-3 node would interpret the
 * same bytes identically (and so the round-trip is unit-testable without a
 * simulator). Encoding is little-endian, length-prefixed for the variable
 * arrays. The NS-2 PacketHeaderClass and the NS-3 ns3::Header both delegate
 * their (de)serialization to these functions.
 */
#ifndef ANTHOCNET_CORE_ANT_MESSAGE_CODEC_H
#define ANTHOCNET_CORE_ANT_MESSAGE_CODEC_H

#include <cstddef>
#include <cstdint>
#include <vector>

#include "anthocnet/core/ant_message.h"

namespace anthocnet {
namespace core {
namespace codec {

/// On-wire format version, written at offset 0 of every frame and checked
/// before any other field (ADR-0006). Bump on any layout/semantic change.
/// Both adapter headers must serialize this same value.
/// 0x01: version byte + bounds/enum enforcement (item 12).
/// 0x02: + AntMessage::broadcastBudget field, AntType::LinkFail (item 05).
constexpr std::uint8_t kWireVersion = 0x02;

/// Protocol bounds enforced on *decode* of untrusted input, mirroring the
/// Config defaults so the codec stays standalone (golden rule #5). A frame
/// declaring more elements than these is rejected, not just buffer-checked.
constexpr std::uint16_t kMaxVisitedOnWire = 100;   ///< == Config::maxPathLength
constexpr std::uint16_t kMaxHistoryOnWire = 100;   ///< retraced path ≤ path length
constexpr std::uint16_t kMaxHelloOnWire   = 64;    ///< generous bound on adverts

/// Number of bytes serialize() will produce for `msg`.
std::size_t serializedSize(const AntMessage& msg);

/// Encode `msg` into a fresh byte buffer.
std::vector<std::uint8_t> serialize(const AntMessage& msg);

/// Encode `msg` into `out` (resized to serializedSize(msg)).
void serialize(const AntMessage& msg, std::vector<std::uint8_t>& out);

/// Decode `bytes` into `msg`. Returns false if the buffer is truncated or
/// internally inconsistent; on failure `msg` is left in an unspecified state.
bool deserialize(const std::uint8_t* bytes, std::size_t len, AntMessage& msg);

inline bool deserialize(const std::vector<std::uint8_t>& bytes, AntMessage& msg) {
    return deserialize(bytes.data(), bytes.size(), msg);
}

} // namespace codec
} // namespace core
} // namespace anthocnet

#endif // ANTHOCNET_CORE_ANT_MESSAGE_CODEC_H
