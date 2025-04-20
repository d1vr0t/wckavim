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
      system = "x86_64-linux";
      
      vimconfig = import ./wckavim.nix;
      pkgs = import nixpkgs { inherit system; };

    in
    {

      packages."${system}" = {
        wckavim = nixvim.legacyPackages."${system}".makeNixvimWithModule {
          inherit pkgs;
          module = vimconfig;
        };
        wckavim-offline = pkgs.writeShellApplication {
          name = "nvim";
          runtimeInputs = [
            pkgs.bubblewrap
            self.packages."${system}.wckavim"
          ];
          text = ''
            bwrap --unshare-net nvim}
          '';

        };
        default = self.packages."${system}".wckavim;
      };

    };
}
