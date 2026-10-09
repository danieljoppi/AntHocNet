# AOMDV baseline ns-3 module (ns-3.36+ CMake build) — vendored for #296.
#
# Installed into $(NS3DIR)/contrib/aomdv by `make install-ns3`, alongside the
# anthocnet module. Provenance: stock ns-3.36 src/aodv rebased with the AOMDV
# delta from CharithaS/Implementation-of-AOMDV-Routing-Protocol-in-ns-3
# (GPLv2) — see README.md in this directory.
#
# Adapt to ns-3 API drift by release, mirroring the anthocnet module's
# CMakeLists (same NS3_VER regex, same two pre-3.37 gates, same scoped-test-enum
# gate). NS3_VER is set by ns-3 (e.g. "3.41"); anything non-numeric (e.g.
# "3-dev") falls through to the modern defaults.
#  - RouteInput callbacks went from by-value to const-reference in ns-3.37.
#  - WifiMacQueueItem was renamed to WifiMpdu (header wifi-mac-queue-item.h ->
#    wifi-mpdu.h) in ns-3.37; the WifiMac "DroppedMpdu" trace carries this type.
#  - TestSuite/TestCase enums became scoped (enum class) in ns-3.42, and the
#    deprecated unscoped aliases were removed in ns-3.47.
if(NS3_VER MATCHES "^3\\.([0-9]+)")
  if(CMAKE_MATCH_1 LESS 37)
    add_compile_definitions(AOMDV_NS3_ROUTEINPUT_BYVALUE)
    add_compile_definitions(AOMDV_NS3_WIFI_QUEUE_ITEM)
  endif()
  if(CMAKE_MATCH_1 GREATER_EQUAL 42)
    add_compile_definitions(AOMDV_NS3_SCOPED_TEST_ENUMS)
  endif()
else()
  add_compile_definitions(AOMDV_NS3_SCOPED_TEST_ENUMS)
endif()

build_lib(
  LIBNAME aomdv
  SOURCE_FILES
    model/aomdv-id-cache.cc
    model/aomdv-dpd.cc
    model/aomdv-rtable.cc
    model/aomdv-rqueue.cc
    model/aomdv-packet.cc
    model/aomdv-neighbor.cc
    model/aomdv-routing-protocol.cc
    helper/aomdv-helper.cc
  HEADER_FILES
    model/aomdv-id-cache.h
    model/aomdv-dpd.h
    model/aomdv-rtable.h
    model/aomdv-rqueue.h
    model/aomdv-packet.h
    model/aomdv-neighbor.h
    model/aomdv-routing-protocol.h
    helper/aomdv-helper.h
  LIBRARIES_TO_LINK
    ${libinternet}
    # wifi: the model subscribes to the WifiMac "DroppedMpdu" trace for MAC
    # transmit-failure detection (inherited from the stock ns-3.36 aodv base).
    ${libwifi}
  TEST_SOURCES
    test/aomdv-id-cache-test-suite.cc
)
