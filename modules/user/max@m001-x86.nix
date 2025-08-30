{
  lib,
  pkgs,
  ...
}:
lib.mkUser {
  name = "max";
  description = "Max Karou";

  # Enable "sudo" access.
  extraGroups = [ "wheel" ];

  # Install user dependencies.
  packages = builtins.attrValues {
    inherit (pkgs)
      hyperfine
      ripgrep
      jq
      ;
  };

  # Install user secrets.
  # See: "github:52/nix-secrets"
  secrets = {
    "ssh/id_max" = {
      mode = "0400";
      target = ".ssh/id_ed25519";
    };

    "ssh/id_max.pub" = {
      mode = "0444";
      target = ".ssh/id_ed25519.pub";
    };
  };

  home = {
    # Configure the "git" module.
    # See: "home/git.nix"
    git = {
      enable = true;
      name = "Max Karou";
      email = "maxkarou@protonmail.com";
    };

    # Configure the "ssh" module.
    # See: "home/ssh.nix"
    ssh = {
      enableGitIntegration = true;
      enableGitSigning = true;
    };
  };

  # Tracks the original version for compatibility.
  # This should almost never be changed after the first installation.
  # See: https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  stateVersion = "24.11";
}
