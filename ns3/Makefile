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
	@echo ""
	@echo ">> Done. Reconfigure and build ns-3:"
	@echo "     cd $(NS3DIR) && ./ns3 configure --enable-examples --enable-tests && ./ns3 build"
	@echo "   Run:    ./ns3 run anthocnet-example"
	@echo "   Test:   ./test.py -s anthocnet"

uninstall: require-ns3dir
	@echo ">> Removing $(DEST)"
	rm -rf "$(DEST)"
	@echo ">> Done. Reconfigure/build ns-3 to drop the module."
