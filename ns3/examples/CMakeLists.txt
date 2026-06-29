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
