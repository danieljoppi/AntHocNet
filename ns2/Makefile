# AntHocNet — NS-2 installer.
#
#   make install   NS2DIR=/path/to/ns-allinone-2.3x/ns-2.3x
#   make uninstall NS2DIR=/path/to/ns-allinone-2.3x/ns-2.3x
#   make check     NS2DIR=/path/to/ns-allinone-2.3x/ns-2.3x
#
# install copies the shared core/ and the ns2/ adapter into $(NS2DIR)/anthocnet
# and applies the (idempotent, anchor-based) source patch. You then rebuild
# NS-2 yourself. Nothing here ships a copy of NS-2.

NS2DIR ?=
HERE   := $(abspath $(CURDIR))
ROOT   := $(abspath $(CURDIR)/..)
CORE   := $(ROOT)/core
DEST    = $(NS2DIR)/anthocnet

.PHONY: install uninstall check require-ns2dir

require-ns2dir:
	@if [ -z "$(NS2DIR)" ]; then \
	  echo "error: set NS2DIR, e.g. make install NS2DIR=/opt/ns-allinone-2.35/ns-2.35"; exit 1; fi
	@if [ ! -d "$(NS2DIR)" ]; then echo "error: NS2DIR '$(NS2DIR)' not found"; exit 1; fi
	@if [ ! -f "$(NS2DIR)/common/packet.h" ]; then \
	  echo "error: '$(NS2DIR)' does not look like an ns-2 source tree"; exit 1; fi

install: require-ns2dir
	@echo ">> Installing AntHocNet sources into $(DEST)"
	mkdir -p "$(DEST)/core"
	# Shared core headers.
	cp $(CORE)/include/anthocnet/core/*.h "$(DEST)/core/"
	# Shared core sources, renamed .cc so NS-2's .cc.o rule compiles them.
	@for f in $(CORE)/src/*.cpp; do \
	  base=$$(basename $$f .cpp); \
	  cp $$f "$(DEST)/core/$$base.cc"; \
	done
	# NS-2 adapter sources.
	cp $(HERE)/src/*.h $(HERE)/src/*.cc "$(DEST)/"
	@echo ">> Applying source patch"
	bash $(HERE)/patch/apply-patch.sh "$(NS2DIR)"
	@echo ""
	@echo ">> Done. Rebuild NS-2:"
	@echo "     cd $(NS2DIR) && ./configure && make    # or 'make' if already configured"
	@echo "   (If your compiler defaults below C++14, add -std=c++14 to CCOPT in $(NS2DIR)/Makefile.)"

uninstall: require-ns2dir
	@echo ">> Reverting source patch"
	bash $(HERE)/patch/revert-patch.sh "$(NS2DIR)"
	@echo ">> Removing $(DEST)"
	rm -rf "$(DEST)"
	@echo ">> Done. Rebuild NS-2 to drop the AntHocNet objects."

check: require-ns2dir
	@echo ">> AntHocNet patch status in $(NS2DIR):"
	@grep -rl "ANTHOCNET-BEGIN" "$(NS2DIR)/common" "$(NS2DIR)/trace" \
	   "$(NS2DIR)/tcl/lib" "$(NS2DIR)/Makefile.in" 2>/dev/null || true
	@if [ -d "$(DEST)" ]; then echo "  sources present: $(DEST)"; else echo "  sources NOT installed"; fi
