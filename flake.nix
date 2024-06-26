{
  description = "Nix again";

  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
    substituters = [
      # replace official cache with a mirror located in China
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirrors.bfsu.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];

    # nix community's cache server
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    latest.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    nix-inspect.url = "github:bluskript/nix-inspect";
    nix-inspect.inputs.nixpkgs.follows = "nixpkgs";

    my-nixvim.url = "github:juxtaly/nixvim";
    my-nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        ./nixosModules
        ./hosts
        ./devShells
        ./overlays
      ];
      systems = ["x86_64-linux"];

      flake = {
        # Any flake outputs
      };

      perSystem = {system, ...}: {
        #  _module.args.pkgs = import inputs.nixpkgs {
        #    inherit system;
        #    overlays = [
        #      (final: prev: {
        #      })
        #    ];
        #  };
      };
    };
}
