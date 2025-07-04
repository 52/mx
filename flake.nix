{
  description = "A modular, multi-host nixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vim-overlay = {
      url = "github:52/vim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      systems = [
        "x86_64-linux"
      ];

      # generate an attribute set for each system
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});

      # generate 'nixpkgs' for each system
      pkgsFor = lib.genAttrs systems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );

      # custom lib, see: 'lib'
      lib = nixpkgs.lib.extend (_: _: import ./lib { inherit inputs; });

      # custom packages, see: 'pkgs'
      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });

      # custom overlays, see: 'overlays'
      overlays = import ./overlays { inherit inputs; };

      specialArgs = {
        inherit lib inputs outputs;
      };
    in
    {
      inherit overlays packages;

      # formatter used by 'nix fmt', see: https://nix-community.github.io/nixpkgs-fmt
      formatter = forEachSystem (pkgs: pkgs.nixfmt-rfc-style);

      # shell used by 'nix develop', see: https://nix.dev/manual/nix/2.17/command-ref/new-cli/nix3-develop
      devShells = forEachSystem (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            # nix
            nixfmt-rfc-style
            deadnix
            statix
            nixd

            # secrets
            sops
            age
          ];
        };
      });

      nixosConfigurations = {
        m001-x86 = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./hosts/m001-x86
          ];
        };
      };
    };
}
