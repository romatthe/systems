{ pkgs, ... }:

let
  # Elixir 1.12
  elixir_12 = (pkgs.beam.packagesWith pkgs.erlangR24).elixir.override {
    version = "1.12.3";
    # nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/refs/tags/v1.12.3.tar.gz
    sha256 = "07fisdx755cgyghwy95gvdds38sh138z56biariml18jjw5mk3r6";
  };
  # Elixir LS 0.7 with Elixir 1.12.3
  elixir_ls7 = pkgs.elixir_ls.override {
    elixir = elixir_12;
  };
in
{
  home.packages = with pkgs; [
    # Elixir
    erlangR24
    elixir_12
    elixir_ls7

    # Golang
    go
    gopls
    delve
  ];
}
