{
  description = "Martin's NixOS configuration";

  inputs = {
    # REPOSITORIO NIXOS
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # CLIENTE APPLE MUSIC
    sidra.url = "github:wimpysworld/sidra";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.g14 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
    # PERMITE QUE CONFIGURATION.NIX ACCEDA A SIDRA
      specialArgs = {
        inherit inputs;
      };

      modules = [
        ./configuration.nix
      ];
    };
  };
}
