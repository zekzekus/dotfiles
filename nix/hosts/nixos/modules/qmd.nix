# Vulkan wrapper for qmd (pnpm-installed @tobilu/qmd).
#
# node-llama-cpp ships a prebuilt Vulkan addon (llama-addon.node), but on
# NixOS the addon's NEEDED libs (libvulkan.so.1, libstdc++.so.6) aren't on
# the default dynamic linker search path. This wrapper injects them via
# LD_LIBRARY_PATH so the addon loads and qmd offloads embedding / reranking /
# generation to the iGPU (RADV RENOIR on this host) instead of the CPU.
#
# `~/bin` is earlier in PATH than `~/.local/share/pnpm/bin`, so this shim
# transparently shadows the pnpm-installed binary.
{pkgs, ...}: {
  home.file."bin/qmd" = {
    executable = true;
    text = ''
      #!${pkgs.runtimeShell}
      export LD_LIBRARY_PATH="${pkgs.vulkan-loader}/lib:${pkgs.stdenv.cc.cc.lib}/lib:/run/opengl-driver/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      exec "$HOME/.local/share/pnpm/bin/qmd" "$@"
    '';
  };
}
