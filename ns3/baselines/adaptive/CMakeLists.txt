# Adaptive-routing comparator module (ns-3.36+ CMake build) — the v2.5.0 arms
# of the AntHocNet comparison harness (#563): ARA (#586), Termite (#587) and
# tabular Q-routing (#588), each written from its paper. Provenance, the
# fidelity sheet of every parameter and each deviation are in README.md next
# to this file.
#
# Installed into $(NS3DIR)/contrib/adaptive by `make install-ns3`, alongside
# the anthocnet, aomdv, gpsr and oracle modules.
#
# Adapt to ns-3 API drift by release, as the other vendored modules do.
# NS3_VER is set by ns-3 (e.g. "3.41"); anything non-numeric (e.g. "3-dev")
# falls through to the modern defaults.
#  - RouteInput callbacks went from by-value to const-reference in ns-3.37,
#    the release that also renamed WifiMacQueueItem to WifiMpdu.
#  - TestSuite/TestCase enums became scoped (enum class) in ns-3.42, and the
#    deprecated unscoped aliases were removed in ns-3.47.
if(NS3_VER MATCHES "^3\\.([0-9]+)")
  if(CMAKE_MATCH_1 LESS 37)
    add_compile_definitions(ADAPTIVE_NS3_ROUTEINPUT_BYVALUE)
  endif()
  if(CMAKE_MATCH_1 GREATER_EQUAL 42)
    add_compile_definitions(ADAPTIVE_NS3_SCOPED_TEST_ENUMS)
  endif()
else()
  add_compile_definitions(ADAPTIVE_NS3_SCOPED_TEST_ENUMS)
endif()

build_lib(
  LIBNAME adaptive
  SOURCE_FILES
    model/adaptive-routing-base.cc
    model/adaptive-packet.cc
    model/ara-routing-protocol.cc
    model/termite-routing-protocol.cc
    model/qrouting-routing-protocol.cc
    helper/adaptive-helper.cc
  HEADER_FILES
    model/adaptive-routing-base.h
    model/adaptive-packet.h
    model/adaptive-tables.h
    model/ara-routing-protocol.h
    model/termite-routing-protocol.h
    model/qrouting-routing-protocol.h
    helper/adaptive-helper.h
  LIBRARIES_TO_LINK
    ${libcore}
    ${libnetwork}
    ${libinternet}
    # wifi: the "DroppedMpdu" MAC transmit-failure trace (link loss) and the
    # promiscuous overhearing Termite learns from.
    ${libwifi}
  TEST_SOURCES
    test/adaptive-test-suite.cc
)
