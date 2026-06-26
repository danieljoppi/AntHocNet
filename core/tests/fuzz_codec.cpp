// libFuzzer entry point for the untrusted decode path. The codec is the only
// parser of network bytes, so it must never crash, over-read, or over-allocate
// on arbitrary input. Build with:
//   cmake -DANTHOCNET_FUZZ=ON -DCMAKE_CXX_COMPILER=clang++ ..
// and run the resulting `fuzz_codec` binary (clang -fsanitize=fuzzer,address).
#include <cstddef>
#include <cstdint>

#include "anthocnet/core/ant_message.h"
#include "anthocnet/core/ant_message_codec.h"

extern "C" int LLVMFuzzerTestOneInput(const uint8_t* data, size_t size) {
    anthocnet::core::AntMessage msg;
    anthocnet::core::codec::deserialize(data, size, msg);  // must never crash/UB
    return 0;
}
