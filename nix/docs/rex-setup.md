# Rex remote access to NixOS

Rex's official Home Manager module installs the pinned **preview** release on
`nixos`. Its personal user service runs as `zekus`; existing lingering keeps it
running after logout and starts it at boot. Built-in Tailscale exposes it as
`nixos-rex`, accessible only to its enrolling Tailscale account.

After `make nixos`, run `systemctl --user start rex`, then `rex server status`
for the enrollment link and HTTPS address. Enable MagicDNS and HTTPS in your
tailnet. On the Mac, connect Tailscale with the same account and use Rex's
**Add Remote Host…** with that address. Keep the Rex node untagged for owner-only
access. See the [upstream remote-access guide](https://www.superlogical.com/rex/docs/linux/remote-access)
for details and troubleshooting.

`make update` includes Rex; `nix flake update rex` updates only its preview pin.
After applying an update or hostname change with `make nixos`, run
`systemctl --user restart rex` when ready: activation preserves the running
server, while an explicit restart ends its terminal sessions.
