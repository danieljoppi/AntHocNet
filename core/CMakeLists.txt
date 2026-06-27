cmake_minimum_required(VERSION 3.10)
# Keep VERSION in sync with the top-level VERSION file (the release workflow
# checks the git tag against it).
project(anthocnet_core VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

add_compile_options(-Wall -Wextra)

add_library(anthocnet_core STATIC
  src/pheromone_table.cpp
  src/pheromone_engine.cpp
  src/ant_history.cpp
  src/ant_message_codec.cpp
  src/ant_router_logic.cpp
)
target_include_directories(anthocnet_core PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

# The core has no simulator dependency, so it builds and tests standalone.
enable_testing()
add_subdirectory(tests)
