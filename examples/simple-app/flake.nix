{
  description = "A simple ruby app demo";
  inputs = {
    nixpkgs.url = "nixpkgs";
    ruby-nix.url = "github:sagittaros/ruby-nix";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, ruby-nix, flake-utils }:
    flake-utils.lib.eachSystem [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ]
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ ruby-nix.overlays.ruby ];
          };
          rubyNix = ruby-nix.lib pkgs;
          ruby = pkgs.ruby_3_1; # if you want to override the default ruby version

          inherit (rubyNix {
            ruby = pkgs.ruby_3_1; # if you want to override the default ruby version
            name = "simple-ruby-app";
            gemset = ./gemset.nix;
          }) env envMinimal;
        in
        {
          devShells = rec {
            default = dev;
            dev = pkgs.mkShell {
              buildInputs = [ env ];
            };
          };
        });
}
