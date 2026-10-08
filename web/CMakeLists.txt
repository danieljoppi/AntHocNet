# The browser adapter (#544, ADR-0021). One source set, two builds:
#   native:      cmake -S web -B web/build && cmake --build web/build
#   WebAssembly: emcmake cmake -S web -B web/build-wasm && cmake --build web/build-wasm
# Both produce ahn-web-trace (the parity runner); the WASM build also produces
# the ES module the learn site loads (anthocnet.js + anthocnet.wasm).
cmake_minimum_required(VERSION 3.10)
project(anthocnet_web LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()
add_compile_options(-Wall -Wextra)
# Parity: no floating-point contraction (an FMA on one side would change the
# last bit), no fast-math anywhere.
add_compile_options(-ffp-contract=off)

set(CORE ${CMAKE_CURRENT_SOURCE_DIR}/../core)
add_library(ahn_web STATIC
  ${CORE}/src/pheromone_table.cpp
  ${CORE}/src/pheromone_engine.cpp
  ${CORE}/src/ant_history.cpp
  ${CORE}/src/ant_message_codec.cpp
  ${CORE}/src/ant_router_logic.cpp
  ${CORE}/src/link_metric_registry.cpp
  src/sim.cpp
  src/scenarios.cpp)
target_include_directories(ahn_web PUBLIC ${CORE}/include include)

add_executable(ahn-web-trace src/trace_main.cpp)
target_link_libraries(ahn-web-trace ahn_web)

if(EMSCRIPTEN)
  target_link_options(ahn-web-trace PRIVATE -sENVIRONMENT=node -sALLOW_MEMORY_GROWTH=1
                      -sNODERAWFS=1)
  add_executable(anthocnet src/bindings.cpp)
  target_link_libraries(anthocnet ahn_web)
  target_link_options(anthocnet PRIVATE --bind -sMODULARIZE=1 -sEXPORT_ES6=1
                      -sEXPORT_NAME=createAntHocNet -sENVIRONMENT=web,worker,node
                      -sALLOW_MEMORY_GROWTH=1 -sFILESYSTEM=0)
endif()
