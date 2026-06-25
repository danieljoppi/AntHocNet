/*
 * NS-3 on-the-wire header for AntHocNet, carrying a core::AntMessage.
 *
 * Unlike NS-2, NS-3 packet headers are real ns3::Header objects with explicit
 * Serialize/Deserialize, so the variable-length visited path is encoded
 * directly (no fixed-capacity arrays). The byte layout matches
 * core/ant_message_codec so an NS-2 and an NS-3 node would agree on the wire.
 */
#ifndef ANTHOCNET_PACKET_H
#define ANTHOCNET_PACKET_H

#include "ns3/header.h"

#include "anthocnet/core/ant_message.h"

namespace ns3 {
namespace anthocnet {

class AntHeader : public Header
{
public:
    AntHeader() = default;
    explicit AntHeader(const ::anthocnet::core::AntMessage& msg) : m_message(msg) {}

    static TypeId GetTypeId();
    TypeId GetInstanceTypeId() const override;

    uint32_t GetSerializedSize() const override;
    void Serialize(Buffer::Iterator start) const override;
    uint32_t Deserialize(Buffer::Iterator start) override;
    void Print(std::ostream& os) const override;

    const ::anthocnet::core::AntMessage& Message() const { return m_message; }
    ::anthocnet::core::AntMessage& Message() { return m_message; }
    void SetMessage(const ::anthocnet::core::AntMessage& m) { m_message = m; }

private:
    ::anthocnet::core::AntMessage m_message;
};

} // namespace anthocnet
} // namespace ns3

#endif // ANTHOCNET_PACKET_H
