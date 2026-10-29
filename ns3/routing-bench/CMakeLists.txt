# routing-bench: the protocol-agnostic comparison harness (ADR-0027, epic
# #764). This step (#766) carries the arm contract, the arm registry and the
# arms of stock ns-3 (aodv, olsr, dsdv, hwmp). It links only stock ns-3 and
# names no other arm: arm modules depend on routing-bench, never the reverse.
#
# Installed into $(NS3DIR)/contrib/routing-bench by `make install-ns3`,
# alongside the comparison modules.
#
# Adapt to ns-3 API drift by release, as the other modules do. NS3_VER is set
# by ns-3 (e.g. "3.41"); anything non-numeric (e.g. "3-dev") falls through to
# the modern defaults.
#  - RouteInput callbacks went from by-value to const-reference in ns-3.37.
#  - TestSuite/TestCase enums became scoped (enum class) in ns-3.42, and the
#    deprecated unscoped aliases were removed in ns-3.47.
if(NS3_VER MATCHES "^3\\.([0-9]+)")
  if(CMAKE_MATCH_1 LESS 37)
    add_compile_definitions(ROUTING_BENCH_NS3_ROUTEINPUT_BYVALUE)
  endif()
  if(CMAKE_MATCH_1 GREATER_EQUAL 42)
    add_compile_definitions(ROUTING_BENCH_NS3_SCOPED_TEST_ENUMS)
  endif()
else()
  add_compile_definitions(ROUTING_BENCH_NS3_SCOPED_TEST_ENUMS)
endif()

build_lib(
  LIBNAME routing-bench
  SOURCE_FILES
    model/routing-bench-arm.cc
    model/source-refusal-counter.cc
    helper/stock-arms.cc
  HEADER_FILES
    model/routing-bench-arm.h
    model/source-refusal-counter.h
    helper/stock-arms.h
  LIBRARIES_TO_LINK
    ${libcore}
    ${libnetwork}
    ${libinternet}
    ${libaodv}
    ${libolsr}
    ${libdsdv}
  TEST_SOURCES
    test/routing-bench-test-suite.cc
)
