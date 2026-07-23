.PHONY: help home home-build darwin darwin-build nixos nixos-build update update-neovim update-amp update-helium update-pinned check fmt clean

USER := $(shell whoami)
HOST := $(shell hostname -s)
FLAKE := .
UNAME := $(shell uname)

help:
	@echo "Dotfiles Management"
	@echo "==================="
	@echo ""
	@echo "Detected: $(USER)@$(HOST)"
	@echo ""
	@echo "Available commands:"
	@echo "  make home          - Switch home-manager only (faster iteration)"
	@echo "  make home-build    - Build home-manager only (dry-run)"
	@echo "  make darwin        - Rebuild nix-darwin system (macOS)"
	@echo "  make darwin-build  - Build nix-darwin system without switching"
	@echo "  make nixos         - Rebuild NixOS system (requires NixOS)"
	@echo "  make nixos-build   - Build NixOS system without switching"
	@echo "  make update        - Update flake inputs (including Neovim nightly) + pinned versions"
	@echo "  make update-neovim - Update only the pinned Neovim nightly"
	@echo "  make update-amp    - Pin amp.nix to latest published amp version"
	@echo "  make update-helium - Pin helium.nix to latest helium-linux release"
	@echo "  make update-pinned - Run all pinned-version updaters (amp + helium)"
	@echo "  make check         - Run all checks (format, deadnix, statix)"
	@echo "  make fmt           - Format all Nix files with alejandra"
	@echo "  make clean         - Clean build artifacts"
	@echo ""

home:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		echo "Error: home-manager is integrated into the darwin system here (no standalone homeConfigurations for this host)."; \
		echo "Use 'make darwin' instead — it applies your home config too."; \
		exit 1; \
	fi
	@echo "Switching home-manager for $(USER)@$(HOST)..."
	home-manager switch --impure --flake $(FLAKE)#$(USER)@$(HOST)

home-build:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		echo "Error: home-manager is integrated into the darwin system here (no standalone homeConfigurations for this host)."; \
		echo "Use 'make darwin-build' instead."; \
		exit 1; \
	fi
	@echo "Building home-manager for $(USER)@$(HOST)..."
	nix build --impure --dry-run $(FLAKE)#homeConfigurations.\"$(USER)@$(HOST)\".activationPackage

darwin:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		echo "Rebuilding nix-darwin for $(HOST)..."; \
		sudo darwin-rebuild switch --impure --flake $(FLAKE)#$(HOST); \
	else \
		echo "Error: Not a macOS system"; \
		exit 1; \
	fi

darwin-build:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		echo "Building nix-darwin for $(HOST)..."; \
		nix build --impure $(FLAKE)#darwinConfigurations.$(HOST).system; \
	else \
		echo "Error: Not a macOS system"; \
		exit 1; \
	fi

nixos:
	@if [ -f /etc/NIXOS ]; then \
		echo "Rebuilding NixOS system $(HOST)..."; \
		sudo nixos-rebuild switch --impure --flake $(FLAKE)#$(HOST); \
	else \
		echo "Error: Not a NixOS system"; \
		exit 1; \
	fi

nixos-build:
	@if [ -f /etc/NIXOS ]; then \
		echo "Building NixOS system $(HOST)..."; \
		nix build --impure --dry-run $(FLAKE)#nixosConfigurations.$(HOST).config.system.build.toplevel; \
	else \
		echo "Error: Not a NixOS system"; \
		exit 1; \
	fi

update: update-pinned
	@echo "Updating flake inputs..."
	nix flake update

update-neovim:
	@echo "Updating Neovim nightly..."
	nix flake update neovim-nightly-overlay

update-amp:
	@./scripts/update-amp

update-helium:
	@./scripts/update-helium

update-pinned: update-amp update-helium

check:
	@echo "Checking flake..."
	nix flake check --impure

fmt:
	@echo "Formatting Nix files..."
	nix fmt

clean:
	@echo "Cleaning build artifacts..."
	rm -rf result
