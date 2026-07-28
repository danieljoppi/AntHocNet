# Each test is a standalone executable returning non-zero on failure.
set(ANTHOCNET_TESTS
  test_pheromone_table
  test_pheromone_engine
  test_ant_history
  test_codec
  test_router_logic
  test_network_integration
  test_core_paths
  test_beta_selection
  test_backant_metric
  test_diffusion
  test_proactive
  test_link_failure
  test_evaporation_backoff
  test_data_routing
  test_link_metric
  test_link_metric_registry
  test_mac_metric
  test_properties
  test_observability
  test_testbench
  test_reactive_hop_reach
  test_reactive_flood_bound
  test_reactive_source_band
  test_ant_type_gates
)

foreach(test ${ANTHOCNET_TESTS})
  add_executable(${test} ${test}.cpp)
  target_link_libraries(${test} PRIVATE anthocnet_core)
  target_include_directories(${test} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
  add_test(NAME ${test} COMMAND ${test})
endforeach()

# Experiments. Built like a test so they cannot silently rot against core
# changes, but deliberately NOT registered with ctest: their value is the
# numbers they print, not a pass/fail assertion, and a "test" that always
# returns 0 would be noise in the suite. Run one by hand to reproduce the
# finding recorded in the issue its header cites.
set(ANTHOCNET_EXPERIMENTS
  exp_gate_cascade
)

foreach(exp ${ANTHOCNET_EXPERIMENTS})
  add_executable(${exp} ${exp}.cpp)
  target_link_libraries(${exp} PRIVATE anthocnet_core)
  target_include_directories(${exp} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
endforeach()

# Optional libFuzzer target for the untrusted codec (clang only). Off by default
# so the normal build/test stays toolchain-agnostic:
#   cmake -DANTHOCNET_FUZZ=ON -DCMAKE_CXX_COMPILER=clang++ ..
option(ANTHOCNET_FUZZ "Build the codec fuzz target (requires clang libFuzzer)" OFF)
if(ANTHOCNET_FUZZ)
  add_executable(fuzz_codec fuzz_codec.cpp)
  target_link_libraries(fuzz_codec PRIVATE anthocnet_core)
  target_compile_options(fuzz_codec PRIVATE -g -fsanitize=fuzzer,address)
  target_link_options(fuzz_codec PRIVATE -fsanitize=fuzzer,address)
endif()
