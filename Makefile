## Download, validate, and unpack service and plugin binaries
CURL   ?= curl -sSL --fail-with-body
SHASUM ?= shasum --algorithm 256
UNZIP  ?= unzip

include environment

## Nomad
# CACHE += .cache/nomad_$(NOMAD_VERSION)_darwin_amd64.zip
# CACHE += .cache/nomad_$(NOMAD_VERSION)_darwin_arm64.zip
CACHE += .cache/nomad_$(NOMAD_VERSION)_linux_amd64.zip
CACHE += .cache/nomad_$(NOMAD_VERSION)_linux_arm64.zip
CACHE += .cache/nomad_$(NOMAD_VERSION)_SHA256SUMS

## Nomad plugins
CACHE += .cache/nomad-driver-podman_$(NOMAD_PODMAN_VERSION)_linux_amd64.zip
CACHE += .cache/nomad-driver-podman_$(NOMAD_PODMAN_VERSION)_linux_arm64.zip
CACHE += .cache/nomad-driver-podman_$(NOMAD_PODMAN_VERSION)_SHA256SUMS

## Vault
CACHE += .cache/vault_$(VAULT_VERSION)_linux_amd64.zip
CACHE += .cache/vault_$(VAULT_VERSION)_linux_arm64.zip
CACHE += .cache/vault_$(VAULT_VERSION)_SHA256SUMS


CACHE += .cache/vault-yubikey-helper_$(VAULT_YK_HELPER_VERSION)_darwin_amd64.tar.gz
# CACHE += .cache/vault-yubikey-helper_$(VAULT_YK_HELPER_VERSION)_darwin_arm64.zip
CACHE += .cache/vault-yubikey-helper_$(VAULT_YK_HELPER_VERSION)_linux_amd64.tar.gz
# CACHE += .cache/vault-yubikey-helper_$(VAULT_YK_HELPER_VERSION)_linux_arm64.zip

# BINARIES += bin/nomad_$(NOMAD_VERSION)_darwin_amd64
# BINARIES += bin/nomad_$(NOMAD_VERSION)_darwin_arm64
BINARIES += bin/nomad_$(NOMAD_VERSION)_linux_amd64
BINARIES += bin/nomad_$(NOMAD_VERSION)_linux_arm64

BINARIES += bin/nomad-driver-podman_$(NOMAD_PODMAN_VERSION)_linux_amd64
BINARIES += bin/nomad-driver-podman_$(NOMAD_PODMAN_VERSION)_linux_arm64

BINARIES += bin/nomad-usb-device-plugin_$(NOMAD_USB_VERSION)_linux_amd64
BINARIES += bin/nomad-usb-device-plugin_$(NOMAD_USB_VERSION)_linux_arm64

BINARIES += bin/vault_$(VAULT_VERSION)_linux_amd64
BINARIES += bin/vault_$(VAULT_VERSION)_linux_arm64

BINARIES += bin/vault-yubikey-helper_$(VAULT_YK_HELPER_VERSION)_linux_amd64
BINARIES += bin/vault-yubikey-helper_$(VAULT_YK_HELPER_VERSION)_darwin_amd64
BINARIES += bin/vault-yubikey-helper

.PHONY: extract
extract: cache $(BINARIES)

.PHONY: cache
cache: $(CACHE)
	cd .cache; $(SHASUM) --ignore-missing --strict --check nomad_$(NOMAD_VERSION)_SHA256SUMS
	cd .cache; $(SHASUM) --ignore-missing --strict --check nomad-driver-podman_$(NOMAD_PODMAN_VERSION)_SHA256SUMS
	cd .cache; $(SHASUM) --ignore-missing --strict --check vault_$(VAULT_VERSION)_SHA256SUMS

.PHONY: clean
clean:

.PHONY: clobber
clobber: clean
	rm -rf .cache bin

bin/%: .cache/%.zip
	mkdir -p $(@D)
	$(UNZIP) -p $< >$@
	chmod +x $@


bin/%: .cache/%.tar.gz
	mkdir -p $(@D)
	$(TAR) tar -xvzf $< -O >$@
	chmod +x $@

bin/nomad-usb-device-plugin_$(NOMAD_USB_VERSION)_linux_%:
	mkdir -p $(@D)
	$(CURL) -o $@ https://gitlab.com/api/v4/projects/23395095/packages/generic/nomad-usb-device-plugin/$(NOMAD_USB_VERSION)/nomad-usb-device-plugin-linux-$*-$(NOMAD_USB_VERSION)
	chmod +x $@

bin/vault-yubikey-helper: bin/vault-yubikey-helper_$(VAULT_YK_HELPER_VERSION)_$(HOST_PLATFORM)
	ln -sf $(notdir $<) $@

.cache/nomad_$(NOMAD_VERSION)_%:
	mkdir -p $(@D)
	$(CURL) -o $@ https://releases.hashicorp.com/nomad/$(NOMAD_VERSION)/nomad_$(NOMAD_VERSION)_$*

.cache/nomad-driver-podman_$(NOMAD_PODMAN_VERSION)_%:
	mkdir -p $(@D)
	$(CURL) -o $@ https://releases.hashicorp.com/nomad-driver-podman/$(NOMAD_PODMAN_VERSION)/nomad-driver-podman_$(NOMAD_PODMAN_VERSION)_$*

.cache/vault_$(VAULT_VERSION)_%:
	mkdir -p $(@D)
	$(CURL) -o $@ https://releases.hashicorp.com/vault/$(VAULT_VERSION)/vault_$(VAULT_VERSION)_$*

.cache/vault-yubikey-helper_$(VAULT_YK_HELPER_VERSION)_%:
	mkdir -p $(@D)
	$(CURL) -o $@ https://github.com/jmanero/vault-yubikey-helper/releases/download/$(VAULT_YK_HELPER_VERSION)/vault-yubikey-helper_$(VAULT_YK_HELPER_VERSION)_$*
