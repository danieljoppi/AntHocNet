# AntHocNet ns-3 examples.
#
# build_lib (in ../CMakeLists.txt) descends into this directory automatically
# when examples are enabled. Defining the examples here — rather than in the
# module's top-level CMakeLists — is required: build_lib_example relies on
# BLIB_LIBNAME, which ns-3 only sets within build_lib's scope as it processes
# this subdirectory.

build_lib_example(
  NAME anthocnet-example
  SOURCE_FILES anthocnet-example.cc
  LIBRARIES_TO_LINK
    ${libanthocnet}
    ${libcore}
    ${libnetwork}
    ${libinternet}
    ${libwifi}
    ${libmobility}
    ${libapplications}
)

# The comparison harnesses link the vendored baseline modules (aomdv, gpsr,
# oracle, and adaptive for anthocnet-compare). ns-3 skips an example whose module is present but not enabled, but
# a module that is not installed at all leaves its ${lib...} variable empty and
# the example is compiled anyway (seen on ns-3.48 with BASELINES=0, #605). So
# each harness is gated on its contrib modules existing, the same way
# leo-walker is gated on its ns-3 header below.
set(AHN_HAVE_ORACLE FALSE)
if(EXISTS ${PROJECT_SOURCE_DIR}/contrib/oracle/CMakeLists.txt)
  set(AHN_HAVE_ORACLE TRUE)
endif()
set(AHN_HAVE_BASELINES FALSE)
if(AHN_HAVE_ORACLE
   AND EXISTS ${PROJECT_SOURCE_DIR}/contrib/aomdv/CMakeLists.txt
   AND EXISTS ${PROJECT_SOURCE_DIR}/contrib/gpsr/CMakeLists.txt
   AND EXISTS ${PROJECT_SOURCE_DIR}/contrib/adaptive/CMakeLists.txt)
  set(AHN_HAVE_BASELINES TRUE)
else()
  message(STATUS "anthocnet: comparison modules (aomdv, gpsr, oracle, adaptive) not all "
                 "installed -- skipping isl-grid and "
                 "leo-walker (make install-ns3 without BASELINES=0 adds them)")
endif()

# The comparison harness (anthocnet-compare) moved to the routing-bench module
# (ADR-0027, #767): routing-compare, with anthocnet-compare kept there as an
# alias. AntHocNet reaches it as an arm (helper/anthocnet-bench-arms.cc).

# ISL-grid scenario (#214): a static +Grid torus of point-to-point links — the
# LEO inter-satellite-link abstraction — with no mobility and no wifi. Needs
# point-to-point in addition to the comparison example's dependencies, and
# routing-bench for the OLSR source-refusal counter it shares with
# routing-compare (#513).
if(AHN_HAVE_ORACLE AND EXISTS ${PROJECT_SOURCE_DIR}/contrib/routing-bench/CMakeLists.txt)
build_lib_example(
  NAME isl-grid
  SOURCE_FILES isl-grid.cc
  LIBRARIES_TO_LINK
    ${libanthocnet}
    ${libcore}
    ${libnetwork}
    ${libinternet}
    ${libapplications}
    ${libpoint-to-point}
    ${libflow-monitor}
    ${libaodv}
    ${libolsr}
    ${libdsdv}
    # #296 item 1 / #216: the oracle control, exact on this static torus.
    ${liboracle}
    ${librouting-bench}
)
endif()

# #24 control: STOCK baselines only (AODV/OLSR/DSDV) on the identical scenario,
# deliberately NOT linking ${libanthocnet}/${libcore} so no AntHocNet code is in
# the binary — isolates "is the scenario hard" from "does our module break the
# stock protocols".
build_lib_example(
  NAME manet-baselines
  SOURCE_FILES manet-baselines.cc
  LIBRARIES_TO_LINK
    ${libnetwork}
    ${libinternet}
    ${libwifi}
    ${libmobility}
    ${libapplications}
    ${libflow-monitor}
    ${libaodv}
    ${libolsr}
    ${libdsdv}
)

# #192/#297: the time-varying LEO constellation. Its substrate is stock ns-3's
# LeoCircularOrbitMobilityModel (the #193 decision), new in ns-3.48, so it is
# built only where that header exists; on 3.36-3.47 the example is skipped.
# #581: leo-walker links the vendored GPSR (the SAGIN air layer's gpsr3d
# arm), so it needs the comparison modules, which are installed together.
if(AHN_HAVE_BASELINES AND EXISTS ${PROJECT_SOURCE_DIR}/src/mobility/model/leo-circular-orbit-mobility-model.h)
  build_lib_example(
    NAME leo-walker
    SOURCE_FILES leo-walker.cc
    LIBRARIES_TO_LINK
      ${libanthocnet}
      ${libcore}
      ${libnetwork}
      ${libinternet}
      ${libmobility}
      ${libapplications}
      ${libpoint-to-point}
      ${libcsma}
      ${libflow-monitor}
      ${libaodv}
      ${libolsr}
      ${liboracle}
      ${libgpsr}
  )
endif()
