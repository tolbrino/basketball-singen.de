let
  stable = import (fetchTarball { # 20.03 as of 2020-05-02
    url = https://github.com/NixOS/nixpkgs-channels/archive/ab3adfe.tar.gz;
    sha256 = "1m4wvrrcvif198ssqbdw897c8h84l0cy7q75lyfzdsz9khm1y2n1";
  }) {};

  unstable = import (fetchTarball { # unstable as of 2020-05-02
    url = https://github.com/NixOS/nixpkgs-channels/archive/10100a9.tar.gz;
    sha256 = "011f36kr3c1ria7rag7px26bh73d1b0xpqadd149bysf4hg17rln";
  }) {  };
in {
  env = stable.stdenv.mkDerivation {
    name = "basketball-singen-website";
    buildInputs = [
      ## base
      stable.stdenv
      stable.git
      ## node
      stable.nodejs-10_x
      stable.yarn
      ## build tools
      stable.openssl
    ]
    ++ stable.stdenv.lib.optional stable.stdenv.isLinux stable.inotifyTools
    ++ stable.stdenv.lib.optionals stable.stdenv.isDarwin (with stable.darwin.apple_sdk.frameworks; [
      CoreFoundation
      CoreServices
    ]);
  };
}
