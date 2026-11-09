# BUILD FIXTURE ONLY: a generic UEFI/ext4 layout, not your hardware inventory.
# Replace this entire file with the NEW machine's installer-generated file
# before activation. Never reuse another host's UUIDs or reformat disks to
# match these labels. The checks establish evaluation, not bootability.
{modulesPath, ...}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos-example-root";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/nixos-example-efi";
    fsType = "vfat";
  };
}
