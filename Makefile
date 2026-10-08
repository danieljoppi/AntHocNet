# AntHocNet — top-level entry point.
#
# A simulator-agnostic algorithm core (core/) with a thin NS-3 adapter,
# installed as an additive contrib module onto your ns-3 tree. (The NS-2
# adapter shipped through v1.9.0 and was removed in v2.0.0, #307; check out
# the v1.2.0 tag for its last actively supported form.)
#
# Usage:
#   make test                                   # build + run core unit tests
#   make install-ns3  NS3DIR=/path/to/ns-3-dev
#   make uninstall-ns3 NS3DIR=/path/to/ns-3-dev

.PHONY: test core-test install-ns3 uninstall-ns3 clean

test: core-test

core-test:
	cmake -S core -B core/build -DCMAKE_BUILD_TYPE=Release
	cmake --build core/build -j
	cd core/build && ctest --output-on-failure

install-ns3:
	$(MAKE) -C ns3 install NS3DIR=$(NS3DIR)

uninstall-ns3:
	$(MAKE) -C ns3 uninstall NS3DIR=$(NS3DIR)

clean:
	rm -rf core/build
