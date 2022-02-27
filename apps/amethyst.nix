{ stdenv, unzip }:

stdenv.mkDerivation rec {
  pname = "amethyst";
  version = "0.15.5";
  nativeBuildInputs = [unzip];
  src = builtins.fetchurl {
    url = "https://github.com/ianyh/Amethyst/releases/download/v${version}/Amethyst.zip";
    sha256 = "10z6dj8cbvq3zrj3582kxwj52a6d39s6qr8cgrpsq4zz6sf9xlx3";
  };
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    TARGET=$out/Applications/Amethyst.app
    mkdir -p $TARGET
    cp -r . $TARGET/
  '';
}
