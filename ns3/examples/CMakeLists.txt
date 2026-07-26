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

# Protocol comparison (AntHocNet vs AODV/OLSR/DSDV). Only built when those
# modules + flow-monitor are enabled; otherwise ns-3 skips it automatically.
build_lib_example(
  NAME anthocnet-compare
  SOURCE_FILES anthocnet-compare.cc
  LIBRARIES_TO_LINK
    ${libanthocnet}
    ${libcore}
    ${libnetwork}
    ${libinternet}
    ${libwifi}
    ${libmobility}
    ${libapplications}
    ${libflow-monitor}
    # energy (#209): BasicEnergySource/BasicEnergySourceHelper live in the
    # energy module. WifiRadioEnergyModel(Helper) is in wifi, already linked.
    # wifi itself depends on energy in every ns-3 from 3.36 to 3.48, so
    # --enable-modules lists that name wifi already pull energy in; this entry
    # just makes the direct dependency explicit.
    ${libenergy}
    ${libaodv}
    ${libolsr}
    ${libdsdv}
)

# ISL-grid scenario (#214): a static +Grid torus of point-to-point links — the
# LEO inter-satellite-link abstraction — with no mobility and no wifi. Needs
# point-to-point in addition to the comparison example's dependencies.
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
)

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
