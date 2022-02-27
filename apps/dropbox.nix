{ stdenv, undmg }:

stdenv.mkDerivation rec {
  pname = "Dropbox";
  version = "142.4.4197";
  nativeBuildInputs = [undmg];
  src = builtins.fetchurl {
    name = "${pname}-${version}.dmg";
    url = "https://edge.dropboxstatic.com/dbx-releng/client/Dropbox%20${version}.dmg";
    sha256 = "05jcfy5xdyd1b6bmwx2f2b75mnz84ydgb5q5wlc50qn3jq6n6xmi";
  };
  phases = [ "installPhase" ];
  installPhase = ''
    TARGET=$out/Applications/
    mkdir -p $TARGET
    cd $TARGET
    undmg ${src}
  '';
}
