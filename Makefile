.PHONY: help home home-build nixos nixos-build update check clean

USER := $(shell whoami)
HOST := $(shell hostname)
FLAKE := ./home-manager

help:
	@echo "Dotfiles Management"
	@echo "==================="
	@echo ""
	@echo "Detected: $(USER)@$(HOST)"
	@echo ""
	@echo "Available commands:"
	@echo "  make home          - Switch home-manager configuration"
	@echo "  make home-build    - Build home-manager configuration (dry-run)"
	@echo "  make nixos         - Rebuild NixOS system (requires NixOS)"
	@echo "  make nixos-build   - Build NixOS system without switching"
	@echo "  make update        - Update flake inputs"
	@echo "  make check         - Check flake validity"
	@echo "  make clean         - Clean build artifacts"
	@echo ""

home:
	@echo "Switching home-manager for $(USER)@$(HOST)..."
	home-manager switch --impure --flake $(FLAKE)#$(USER)@$(HOST)

home-build:
	@echo "Building home-manager for $(USER)@$(HOST)..."
	nix build --impure --dry-run $(FLAKE)#homeConfigurations.\"$(USER)@$(HOST)\".activationPackage

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
	nix flake update $(FLAKE)

check:
	@echo "Checking flake..."
	nix flake check $(FLAKE) --impure

clean:
	@echo "Cleaning build artifacts..."
	rm -rf result
	cd $(FLAKE) && rm -rf result
