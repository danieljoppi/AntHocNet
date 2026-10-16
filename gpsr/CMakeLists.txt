# GPSR ns-3 module (ns-3.36+ CMake build) — vendored baseline for the
# AntHocNet comparison harness (#296 item 3).
#
# Installed into $(NS3DIR)/contrib/gpsr by `make install-ns3`, alongside the
# anthocnet module. Provenance (source repo, commit, port changes) is in
# README.md next to this file.
#
# Adapt to ns-3 API drift by release, the same way the anthocnet module's
# CMakeLists does. NS3_VER is set by ns-3 (e.g. "3.41"); anything non-numeric
# (e.g. "3-dev") falls through to the modern defaults.
#  - RouteInput callbacks went from by-value to const-reference in ns-3.37.
#  - WifiMacQueueItem was renamed to WifiMpdu (header wifi-mac-queue-item.h ->
#    wifi-mpdu.h) in ns-3.37; the WifiMac "DroppedMpdu" trace carries this type.
if(NS3_VER MATCHES "^3\\.([0-9]+)")
  if(CMAKE_MATCH_1 LESS 37)
    add_compile_definitions(GPSR_NS3_ROUTEINPUT_BYVALUE)
    add_compile_definitions(GPSR_NS3_WIFI_QUEUE_ITEM)
  endif()
endif()

build_lib(
  LIBNAME gpsr
  SOURCE_FILES
    model/gpsr.cc
    model/gpsr-packet.cc
    model/gpsr-ptable.cc
    model/gpsr-rqueue.cc
    helper/gpsr-helper.cc
  HEADER_FILES
    model/gpsr.h
    model/gpsr-packet.h
    model/gpsr-ptable.h
    model/gpsr-rqueue.h
    helper/gpsr-helper.h
  LIBRARIES_TO_LINK
    ${libcore}
    ${libnetwork}
    ${libinternet}
    # wifi: the "DroppedMpdu" MAC transmit-failure trace prunes dead
    # neighbours from the position table. mobility: GPSR is geographic — every
    # node reads positions from MobilityModel (the GOD location service).
    ${libwifi}
    ${libmobility}
)
