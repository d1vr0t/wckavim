{
  description = "Standalone wkca neovim";

  inputs = {
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim,
    }:

    let
      vimconfig = import ./wckavim.nix;
      pkgs = import nixpkgs { system = "x86_64-linux"; };

    in
    {

      packages.x86_64-linux.wckavim = nixvim.legacyPackages."x86_64-linux".makeNixvimWithModule {
        inherit pkgs;
        module = vimconfig;
      };
      packages.x86_64-linux.default = self.packages.x86_64-linux.wckavim;

    };
}
