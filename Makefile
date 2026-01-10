.PHONY: help home home-build darwin darwin-build nixos nixos-build update check fmt clean

USER := $(shell whoami)
HOST := $(shell hostname -s)
FLAKE := ./home-manager
UNAME := $(shell uname)

help:
	@echo "Dotfiles Management"
	@echo "==================="
	@echo ""
	@echo "Detected: $(USER)@$(HOST)"
	@echo ""
	@echo "Available commands:"
	@echo "  make home          - Switch home-manager configuration (standalone)"
	@echo "  make home-build    - Build home-manager configuration (dry-run)"
	@echo "  make darwin        - Rebuild nix-darwin system (macOS)"
	@echo "  make darwin-build  - Build nix-darwin system without switching"
	@echo "  make nixos         - Rebuild NixOS system (requires NixOS)"
	@echo "  make nixos-build   - Build NixOS system without switching"
	@echo "  make update        - Update flake inputs"
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

update:
	@echo "Updating flake inputs..."
	cd $(FLAKE) && nix flake update

check:
	@echo "Checking flake..."
	nix flake check $(FLAKE) --impure

fmt:
	@echo "Formatting Nix files..."
	cd $(FLAKE) && nix fmt .

clean:
	@echo "Cleaning build artifacts..."
	rm -rf result
	cd $(FLAKE) && rm -rf result
