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
