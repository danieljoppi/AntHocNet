# AntHocNet ns-3 module (ns-3.36+ CMake build).
#
# Installed into $(NS3DIR)/contrib/anthocnet by `make install-ns3`. The shared
# algorithm core/ is copied alongside and compiled into the module; its headers
# live under core/include and are added to the include path here.

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/core/include)

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
  TEST_SOURCES
    test/anthocnet-test-suite.cc
)

build_lib_example(
  NAME anthocnet-example
  SOURCE_FILES examples/anthocnet-example.cc
  LIBRARIES_TO_LINK
    ${libanthocnet}
    ${libcore}
    ${libnetwork}
    ${libinternet}
    ${libwifi}
    ${libmobility}
    ${libapplications}
)
