# AntHocNet ns-3 module (ns-3.36+ CMake build).
#
# Installed into $(NS3DIR)/contrib/anthocnet by `make install-ns3`. The shared
# algorithm core/ is copied alongside and compiled into the module; its headers
# live under core/include and are added to the include path here.
#
# Wrap the source-tree include in $<BUILD_INTERFACE:> so it is used only while
# building (not exported for install). ns-3 folds directory include dirs into
# the module target's INTERFACE_INCLUDE_DIRECTORIES, and a raw source path there
# is rejected outright by ns-3.36's CMake ("prefixed in the source directory").
# The genex is inherited by the examples/ subdirectory, so examples and tests
# that pull in the module's public headers still resolve anthocnet/core/*.
include_directories($<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/core/include>)

# Adapt to ns-3 API drift by release. NS3_VER is set by ns-3 (e.g. "3.41");
# anything non-numeric (e.g. "3-dev") falls through to the modern defaults.
# These definitions are directory-scoped, so the library, the examples/
# subdirectory and the test target all see a consistent API.
#  - RouteInput callbacks went from by-value to const-reference in ns-3.37.
#  - TestSuite/TestCase enums became scoped (enum class) in ns-3.42, and the
#    deprecated unscoped aliases were removed in ns-3.47.
#  - WifiMacQueueItem was renamed to WifiMpdu (header wifi-mac-queue-item.h ->
#    wifi-mpdu.h) in ns-3.37; the WifiMac "DroppedMpdu" trace carries this type.
if(NS3_VER MATCHES "^3\\.([0-9]+)")
  if(CMAKE_MATCH_1 LESS 37)
    add_compile_definitions(ANTHOCNET_NS3_ROUTEINPUT_BYVALUE)
    add_compile_definitions(ANTHOCNET_NS3_WIFI_QUEUE_ITEM)
  endif()
  if(CMAKE_MATCH_1 GREATER_EQUAL 42)
    add_compile_definitions(ANTHOCNET_NS3_SCOPED_TEST_ENUMS)
  endif()
else()
  add_compile_definitions(ANTHOCNET_NS3_SCOPED_TEST_ENUMS)
endif()

# Examples are defined in examples/CMakeLists.txt, which build_lib descends into
# automatically. They MUST live there, not here: build_lib_example reads
# BLIB_LIBNAME, which ns-3 only sets inside build_lib's own scope (it descends
# into examples/ from there). Calling build_lib_example in this top-level scope
# leaves BLIB_LIBNAME empty and breaks configure on ns-3.47/3.48.
build_lib(
  LIBNAME anthocnet
  SOURCE_FILES
    model/anthocnet-routing-protocol.cc
    model/anthocnet-packet.cc
    model/anthocnet-rqueue.cc
    model/anthocnet-adapters.cc
    helper/anthocnet-helper.cc
    core/src/pheromone_table.cpp
    core/src/pheromone_engine.cpp
    core/src/ant_history.cpp
    core/src/ant_message_codec.cpp
    core/src/ant_router_logic.cpp
  HEADER_FILES
    model/anthocnet-routing-protocol.h
    model/anthocnet-packet.h
    model/anthocnet-rqueue.h
    model/anthocnet-adapters.h
    helper/anthocnet-helper.h
  LIBRARIES_TO_LINK
    ${libcore}
    ${libnetwork}
    ${libinternet}
    # wifi: the model subscribes to the WifiMac "DroppedMpdu" trace for the MAC
    # transmit-failure detector (ADR-0008 detector D). mobility: used by the
    # link-break test below to move a node out of range.
    ${libwifi}
    ${libmobility}
  TEST_SOURCES
    test/anthocnet-test-suite.cc
)
