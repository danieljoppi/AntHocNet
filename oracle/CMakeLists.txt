# Oracle shortest-path control module (ns-3.36+ CMake build) — the
# global-knowledge upper bound for the AntHocNet comparison harnesses
# (#296 item 1, #216).
#
# Installed into $(NS3DIR)/contrib/oracle by `make install-ns3`, alongside the
# anthocnet and gpsr modules. Design, exactness per propagation model and the
# recompute cadence are in README.md next to this file.
#
# The Dijkstra + first-hop layer is shared, simulator-agnostic code and lives in
# the repository's core/ (with a core unit test, AGENTS.md rule 7); the
# installer copies just that pair of files under core/ here, the same way the
# anthocnet module carries the algorithm core.
include_directories($<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/core/include>)

# Adapt to ns-3 API drift by release, as the anthocnet and gpsr modules do.
# NS3_VER is set by ns-3 (e.g. "3.41"); anything non-numeric (e.g. "3-dev")
# falls through to the modern defaults.
#  - RouteInput callbacks went from by-value to const-reference in ns-3.37.
#  - TestSuite/TestCase enums became scoped (enum class) in ns-3.42, and the
#    deprecated unscoped aliases were removed in ns-3.47.
if(NS3_VER MATCHES "^3\\.([0-9]+)")
  if(CMAKE_MATCH_1 LESS 37)
    add_compile_definitions(ORACLE_NS3_ROUTEINPUT_BYVALUE)
  endif()
  if(CMAKE_MATCH_1 GREATER_EQUAL 42)
    add_compile_definitions(ORACLE_NS3_SCOPED_TEST_ENUMS)
  endif()
else()
  add_compile_definitions(ORACLE_NS3_SCOPED_TEST_ENUMS)
endif()

build_lib(
  LIBNAME oracle
  SOURCE_FILES
    model/oracle-decode-budget.cc
    model/oracle-topology.cc
    model/oracle-routing-protocol.cc
    helper/oracle-helper.cc
    core/src/shortest_path.cpp
  HEADER_FILES
    model/oracle-decode-budget.h
    model/oracle-topology.h
    model/oracle-routing-protocol.h
    helper/oracle-helper.h
  LIBRARIES_TO_LINK
    ${libcore}
    ${libnetwork}
    ${libinternet}
    # wifi + propagation: on a shared medium the oracle derives adjacency from
    # the channel's own propagation-loss chain and the PHYs' tx power /
    # sensitivity. mobility: that budget is a function of node positions.
    ${libwifi}
    ${libpropagation}
    ${libmobility}
  TEST_SOURCES
    test/oracle-test-suite.cc
)
