{ pkgs ? import <nixpkgs> { }, ... }:
let
  linuxPkgs = with pkgs; lib.optional stdenv.isLinux (
    inotifyTools
  );
  macosPkgs = with pkgs; lib.optional stdenv.isDarwin (
    with darwin.apple_sdk.frameworks; [
      # macOS file watcher support
      CoreFoundation
      CoreServices
    ]
  );
in
with pkgs;
mkShell {
  name = "basketball-singen-website";
  buildInputs = [
    ## node
    nodejs-16_x
    (yarn.override { nodejs = nodejs-16_x; }) # v1.22.10
    ## build tools
    openssl
    travis
    # custom pkg groups
    macosPkgs
    linuxPkgs
  ];
}
