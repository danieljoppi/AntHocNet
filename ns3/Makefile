# AntHocNet — NS-3 installer.
#
#   make install   NS3DIR=/path/to/ns-3-dev
#   make uninstall NS3DIR=/path/to/ns-3-dev
#
# AntHocNet is an additive ns-3 module: install drops it (plus the shared
# core/) into $(NS3DIR)/contrib/anthocnet. No core ns-3 files are edited, so
# there is no patch to apply or revert. After installing, reconfigure/build
# ns-3 yourself. Nothing here ships a copy of ns-3.

NS3DIR ?=
HERE   := $(abspath $(CURDIR))
ROOT   := $(abspath $(CURDIR)/..)
CORE   := $(ROOT)/core
DEST    = $(NS3DIR)/contrib/anthocnet
# #296: the vendored GPSR baseline is a second, self-contained contrib module
# (provenance: gpsr/README.md). Installed alongside so the comparison
# harness's gpsr arm builds; the anthocnet module itself does not depend on it.
GPSRDEST = $(NS3DIR)/contrib/gpsr
# Vendored AOMDV baseline module (#296) — installed alongside anthocnet so the
# comparison harness can link it. See aomdv/README.md for provenance.
AOMDV_DEST = $(NS3DIR)/contrib/aomdv
# #296 item 1: the oracle shortest-path control (provenance + design:
# oracle/README.md). Also self-contained, and it carries the one core/ source
# it needs (the Dijkstra layer) the same way the anthocnet module carries the
# algorithm core.
ORACLEDEST = $(NS3DIR)/contrib/oracle

.PHONY: install uninstall require-ns3dir

require-ns3dir:
	@if [ -z "$(NS3DIR)" ]; then \
	  echo "error: set NS3DIR, e.g. make install NS3DIR=/opt/ns-3-dev"; exit 1; fi
	@if [ ! -d "$(NS3DIR)/contrib" ]; then \
	  echo "error: '$(NS3DIR)' does not look like an ns-3 tree (no contrib/)"; exit 1; fi

install: require-ns3dir
	@echo ">> Installing AntHocNet module into $(DEST)"
	mkdir -p "$(DEST)/model" "$(DEST)/helper" "$(DEST)/examples" "$(DEST)/test"
	cp $(HERE)/model/*.h   $(HERE)/model/*.cc   "$(DEST)/model/"
	cp $(HERE)/helper/*.h  $(HERE)/helper/*.cc  "$(DEST)/helper/"
	cp $(HERE)/examples/*.cc "$(DEST)/examples/"
	cp $(HERE)/examples/CMakeLists.txt "$(DEST)/examples/"
	cp $(HERE)/examples/wscript "$(DEST)/examples/" 2>/dev/null || true
	cp $(HERE)/test/*.cc   "$(DEST)/test/"
	cp $(HERE)/CMakeLists.txt "$(DEST)/"
	cp $(HERE)/wscript "$(DEST)/" 2>/dev/null || true
	# Shared algorithm core (headers + sources compiled into the module).
	mkdir -p "$(DEST)/core/include/anthocnet/core" "$(DEST)/core/src"
	cp $(CORE)/include/anthocnet/core/*.h "$(DEST)/core/include/anthocnet/core/"
	cp $(CORE)/src/*.cpp "$(DEST)/core/src/"
	@echo ">> Installing GPSR baseline module into $(GPSRDEST)"
	mkdir -p "$(GPSRDEST)/model" "$(GPSRDEST)/helper"
	cp $(HERE)/gpsr/model/*.h  $(HERE)/gpsr/model/*.cc  "$(GPSRDEST)/model/"
	cp $(HERE)/gpsr/helper/*.h $(HERE)/gpsr/helper/*.cc "$(GPSRDEST)/helper/"
	cp $(HERE)/gpsr/CMakeLists.txt "$(GPSRDEST)/"
	@echo ">> Installing AOMDV baseline module into $(AOMDV_DEST)"
	mkdir -p "$(AOMDV_DEST)/model" "$(AOMDV_DEST)/helper" "$(AOMDV_DEST)/test"
	cp $(HERE)/aomdv/model/*.h  $(HERE)/aomdv/model/*.cc  "$(AOMDV_DEST)/model/"
	cp $(HERE)/aomdv/helper/*.h $(HERE)/aomdv/helper/*.cc "$(AOMDV_DEST)/helper/"
	cp $(HERE)/aomdv/test/*.cc "$(AOMDV_DEST)/test/"
	cp $(HERE)/aomdv/CMakeLists.txt $(HERE)/aomdv/README.md "$(AOMDV_DEST)/"
	@echo ">> Installing oracle control module into $(ORACLEDEST)"
	mkdir -p "$(ORACLEDEST)/model" "$(ORACLEDEST)/helper" "$(ORACLEDEST)/test" \
	         "$(ORACLEDEST)/core/include/anthocnet/core" "$(ORACLEDEST)/core/src"
	cp $(HERE)/oracle/model/*.h  $(HERE)/oracle/model/*.cc  "$(ORACLEDEST)/model/"
	cp $(HERE)/oracle/helper/*.h $(HERE)/oracle/helper/*.cc "$(ORACLEDEST)/helper/"
	cp $(HERE)/oracle/test/*.cc "$(ORACLEDEST)/test/"
	cp $(HERE)/oracle/CMakeLists.txt "$(ORACLEDEST)/"
	cp $(CORE)/include/anthocnet/core/shortest_path.h \
	   "$(ORACLEDEST)/core/include/anthocnet/core/"
	cp $(CORE)/src/shortest_path.cpp "$(ORACLEDEST)/core/src/"
	@echo ""
	@echo ">> Done. Reconfigure and build ns-3:"
	@echo "     cd $(NS3DIR) && ./ns3 configure --enable-examples --enable-tests && ./ns3 build"
	@echo "   Run:    ./ns3 run anthocnet-example"
	@echo "   Test:   ./test.py -s anthocnet"

uninstall: require-ns3dir
	@echo ">> Removing $(DEST)"
	rm -rf "$(DEST)"
	@echo ">> Removing $(GPSRDEST)"
	rm -rf "$(GPSRDEST)"
	@echo ">> Removing $(AOMDV_DEST)"
	rm -rf "$(AOMDV_DEST)"
	@echo ">> Removing $(ORACLEDEST)"
	rm -rf "$(ORACLEDEST)"
	@echo ">> Done. Reconfigure/build ns-3 to drop the modules."
