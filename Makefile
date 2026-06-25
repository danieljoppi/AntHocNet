# AntHocNet — top-level entry point.
#
# A simulator-agnostic algorithm core (core/) with two thin adapters:
#   * NS-2  — installed as a source patch onto your ns-2.3x tree
#   * NS-3  — installed as an additive contrib module onto your ns-3 tree
#
# Usage:
#   make test                                   # build + run core unit tests
#   make install-ns2  NS2DIR=/path/to/ns-2.3x
#   make uninstall-ns2 NS2DIR=/path/to/ns-2.3x
#   make install-ns3  NS3DIR=/path/to/ns-3-dev
#   make uninstall-ns3 NS3DIR=/path/to/ns-3-dev

.PHONY: test core-test install-ns2 uninstall-ns2 check-ns2 install-ns3 uninstall-ns3 clean

test: core-test

core-test:
	cmake -S core -B core/build -DCMAKE_BUILD_TYPE=Release
	cmake --build core/build -j
	cd core/build && ctest --output-on-failure

install-ns2:
	$(MAKE) -C ns2 install NS2DIR=$(NS2DIR)

uninstall-ns2:
	$(MAKE) -C ns2 uninstall NS2DIR=$(NS2DIR)

check-ns2:
	$(MAKE) -C ns2 check NS2DIR=$(NS2DIR)

install-ns3:
	$(MAKE) -C ns3 install NS3DIR=$(NS3DIR)

uninstall-ns3:
	$(MAKE) -C ns3 uninstall NS3DIR=$(NS3DIR)

clean:
	rm -rf core/build
