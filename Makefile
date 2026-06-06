.PHONY: help home home-build darwin darwin-build nixos nixos-build update update-amp update-helium update-nvim update-pinned check fmt clean

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
	@echo "  make update        - Update flake inputs (except neovim-nightly) + pinned versions"
	@echo "  make update-amp    - Pin amp.nix to latest published amp version"
	@echo "  make update-helium - Pin helium.nix to latest helium-linux release"
	@echo "  make update-nvim   - Bump neovim-nightly-overlay to latest nightly"
	@echo "  make update-pinned - Run all pinned-version updaters (amp + helium)"
	@echo "  make check         - Run all checks (format, deadnix, statix)"
	@echo "  make fmt           - Format all Nix files with alejandra"
	@echo "  make clean         - Clean build artifacts"
	@echo ""

home:
	@echo "Switching home-manager for $(USER)@$(HOST)..."
	home-manager switch --impure --flake $(FLAKE)#$(USER)@$(HOST)

home-build:
	@echo "Building home-manager for $(USER)@$(HOST)..."
	nix build --impure --dry-run $(FLAKE)#homeConfigurations.\"$(USER)@$(HOST)\".activationPackage

darwin:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		echo "Rebuilding nix-darwin for $(HOST)..."; \
		darwin-rebuild switch --impure --flake $(FLAKE)#$(HOST); \
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
	@echo "Updating flake inputs (excluding neovim-nightly-overlay)..."
	@inputs=$$(nix eval --raw --impure --expr 'let i = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.root.inputs; in builtins.concatStringsSep " " (builtins.filter (n: n != "neovim-nightly-overlay") (builtins.attrNames i))'); \
	echo "  inputs: $$inputs"; \
	nix flake update $$inputs

update-amp:
	@./scripts/update-amp

update-helium:
	@./scripts/update-helium

update-nvim:
	@echo "Bumping neovim-nightly-overlay to latest nightly..."
	nix flake update neovim-nightly-overlay

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
