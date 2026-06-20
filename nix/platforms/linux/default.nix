# Linux platform layer — applies to EVERY Linux host (NixOS or foreign distro,
# desktop or headless server). Keep this headless-safe: NO GUI apps or desktop
# services. Graphical apps live in profiles/graphical; the Wayland desktop lives
# in profiles/wayland. This is intentionally near-empty and is the home for
# truly Linux-universal user config.
_: {
}
