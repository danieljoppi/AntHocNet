# Each test is a standalone executable returning non-zero on failure.
set(ANTHOCNET_TESTS
  test_pheromone_table
  test_pheromone_engine
  test_ant_history
  test_codec
  test_router_logic
  test_network_integration
  test_core_paths
)

foreach(test ${ANTHOCNET_TESTS})
  add_executable(${test} ${test}.cpp)
  target_link_libraries(${test} PRIVATE anthocnet_core)
  target_include_directories(${test} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
  add_test(NAME ${test} COMMAND ${test})
endforeach()
