BUILD_DIR := build
CARGO := cargo
FIREFOX_VERSION := $(shell curl -sL https://product-details.mozilla.org/1.0/firefox_versions.json | jq -r '.LATEST_FIREFOX_VERSION')
VARIANT := unchained
ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
GPG_KEY := 14F26682D0916CDD81E37B6D61B7B526D98F0353

all: linux windows arm_mac intel_mac

linux: prepare
	@echo "Building for Linux..."
	@echo "$(GECHO_DRIVER_VERSION)"
	@cd "$(BUILD_DIR)/firefox-$(FIREFOX_VERSION)/testing/geckodriver" && \
		$(CARGO) build --release --target x86_64-unknown-linux-musl
	@mv "$(BUILD_DIR)/firefox-$(FIREFOX_VERSION)/target/x86_64-unknown-linux-musl/release/geckodriver" \
		"$(BUILD_DIR)/bin/geckodriver-$(VARIANT)-linux"

arm_mac: prepare
	@echo "Building for ARM Mac..."
	@cd "$(BUILD_DIR)/firefox-$(FIREFOX_VERSION)/testing/geckodriver" && \
		$(CARGO) build --release --target aarch64-apple-darwin
	@mv "$(BUILD_DIR)/firefox-$(FIREFOX_VERSION)/target/aarch64-apple-darwin/release/geckodriver" \
		"$(BUILD_DIR)/bin/geckodriver-$(VARIANT)-arm-mac"

intel_mac: prepare
	@echo "Building for Intel Mac..."
	@cd "$(BUILD_DIR)/firefox-$(FIREFOX_VERSION)/testing/geckodriver" && \
		$(CARGO) build --release --target x86_64-apple-darwin
	@mv "$(BUILD_DIR)/firefox-$(FIREFOX_VERSION)/target/x86_64-apple-darwin/release/geckodriver" \
		"$(BUILD_DIR)/bin/geckodriver-$(VARIANT)-intel-mac"

windows: prepare
	@echo "Building for Windows..."
	@cd build/firefox-$(FIREFOX_VERSION)/testing/geckodriver && \
		$(CARGO) build --release --target x86_64-pc-windows-gnu
	@mv "$(BUILD_DIR)/firefox-$(FIREFOX_VERSION)/target/x86_64-pc-windows-gnu/release/geckodriver.exe" \
		"$(BUILD_DIR)/bin/geckodriver-$(VARIANT)-win.exe"

prepare:
	@echo "Preparing..."
	@mkdir -p "$(BUILD_DIR)/bin"
ifeq ($(shell test -d $(BUILD_DIR)/firefox-$(FIREFOX_VERSION) && echo -n yes), yes)
	@echo "Firefox $(FIREFOX_VERSION) already downloaded, skipping..."
else
	@echo "Downloading Firefox $(FIREFOX_VERSION)..."
	@curl --fail-with-body -Lso "$(BUILD_DIR)/firefox-$(FIREFOX_VERSION).tar.xz" "https://archive.mozilla.org/pub/firefox/releases/$(FIREFOX_VERSION)/source/firefox-$(FIREFOX_VERSION).source.tar.xz"
	@curl --fail-with-body -Lso "$(BUILD_DIR)/firefox-$(FIREFOX_VERSION).tar.xz.asc" "https://archive.mozilla.org/pub/firefox/releases/$(FIREFOX_VERSION)/source/firefox-$(FIREFOX_VERSION).source.tar.xz.asc"
	@gpg --keyserver keyserver.ubuntu.com --recv-keys $(GPG_KEY)
	@gpg --verify "$(BUILD_DIR)/firefox-$(FIREFOX_VERSION).tar.xz.asc" "$(BUILD_DIR)/firefox-$(FIREFOX_VERSION).tar.xz"
	@echo "Extracting Firefox $(FIREFOX_VERSION)..."
	@tar -xf "$(BUILD_DIR)/firefox-$(FIREFOX_VERSION).tar.xz" -C "$(BUILD_DIR)"
	@cd "$(BUILD_DIR)/firefox-$(FIREFOX_VERSION)" && patch -p1 < "$(ROOT_DIR)/unchained.patch"
	@echo "$(FIREFOX_VERSION)" > "$(BUILD_DIR)/FIREFOX_VERSION.txt"
	@grep -m 1 version "$(BUILD_DIR)/firefox-$(FIREFOX_VERSION)/testing/geckodriver/Cargo.toml" | cut -d '"' -f2 > "$(BUILD_DIR)/GECKODRIVER_VERSION.txt"
endif

clean:
	@echo "Cleaning..."
	@rm -rf "$(BUILD_DIR)"

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all               Build all targets (default)"
	@echo "  linux             Build for Linux"
	@echo "  windows           Build for Windows"
	@echo "  arm_mac           Build for ARM (Apple Silicon) Mac"
	@echo "  intel_mac         Build for Intel Mac"
	@echo "  prepare           Prepare build environment"
	@echo "  clean             Clean build environment"
	@echo "  help              Show this help message"

.PHONY: help
