cmake_minimum_required(VERSION 3.10)
# Keep VERSION in sync with the top-level VERSION file (the release workflow
# checks the git tag against it).
project(anthocnet_core VERSION 1.4.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

add_compile_options(-Wall -Wextra)

# Optional gcov instrumentation for coverage reporting (#162). Off by default so
# the normal build/test is bit-for-bit unchanged; CI's `core-coverage` job turns
# it on and post-processes the .gcda/.gcno with gcovr. Applies to the library and
# to everything under tests/ (both need instrumenting to link):
#   cmake -S core -B core/build-coverage -DANTHOCNET_COVERAGE=ON
option(ANTHOCNET_COVERAGE "Build with gcov instrumentation (gcc/clang)" OFF)
if(ANTHOCNET_COVERAGE)
  # -O0 keeps line/branch attribution honest (inlining smears it); the options
  # are appended after CMAKE_CXX_FLAGS_<CONFIG>, so this wins over Release's -O3.
  add_compile_options(--coverage -O0 -g)
  # add_link_options() needs CMake 3.13 and this project declares 3.10;
  # link_libraries() is directory-scoped, propagates into tests/, and CMake
  # passes a leading-dash entry through to the link line verbatim.
  link_libraries(--coverage)
endif()

add_library(anthocnet_core STATIC
  src/pheromone_table.cpp
  src/pheromone_engine.cpp
  src/ant_history.cpp
  src/ant_message_codec.cpp
  src/ant_router_logic.cpp
  src/link_metric_registry.cpp
)
target_include_directories(anthocnet_core PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

# The core has no simulator dependency, so it builds and tests standalone.
enable_testing()
add_subdirectory(tests)
