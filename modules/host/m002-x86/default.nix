{
  lib,
  ...
}:
{
  imports = lib.flatten [
    #
    # ---- Hardware ----
    #
    ./hardware.nix

    #
    # ---- System ----
    #
    (lib.importAll "modules/system")

    #
    # ---- Users ----
    #
    (lib.relativePath "modules/user/max@m002-x86.nix")
  ];

  # Must be a valid DNS label.
  # WARNING: Do not use (_) or you may run into unexpected issues.
  networking.hostName = "m002-x86";

  # The time zone used when displaying times and dates.
  # See: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
  time.timeZone = "Europe/Berlin";

  # Enable the "wayland" module.
  # See: "system/wayland.nix"
  wayland = {
    enable = true;
  };

  # Enable the "docker" module.
  # See: "system/docker.nix"
  docker = {
    enable = true;
    members = [ "max" ];
  };

  # Tracks the original version for compatibility.
  # This should almost never be changed after the first installation.
  # See: https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
