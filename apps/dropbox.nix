{
  stdenv,
  undmg,
}:
stdenv.mkDerivation rec {
  pname = "Dropbox";
  version = "175.4.5569";
  nativeBuildInputs = [undmg];
  src = builtins.fetchurl {
    name = "${pname}-${version}.dmg";
    url = "https://edge.dropboxstatic.com/dbx-releng/client/Dropbox%20${version}.dmg";
    sha256 = "sha256:0b6gl19mkm0i76kg789c08aybqslw5yb0p57rs73fnj3grpygf6y";
  };
  phases = ["installPhase"];
  installPhase = ''
    TARGET=$out/Applications/
    mkdir -p $TARGET
    cd $TARGET
    undmg ${src}
  '';
}
