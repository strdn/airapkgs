{ stdenv, buildGoPackage, fetchFromGitHub }:
#, fetchhg, fetchbzr, fetchsvn 

buildGoPackage rec {
  name = "yggdrasil-go-unstable-${version}";
  version = "0.3.10";
  rev = "v${version}";

  goPackagePath = "github.com/yggdrasil-network/yggdrasil-go";

  src = fetchFromGitHub {
    owner = "yggdrasil-network";
    repo = "yggdrasil-go";
    rev = "v${version}";
    sha256 = "1h1xqg144adbgsiz00hjzxslakwfp3c5y8myczqq8nv46m29v110";
  };

  prePatch = ''
    sed -i "s/^PKGNAME.*/PKGNAME=yggdrasil/g" ./build
    sed -i "s/^PKGVER.*/PKGVER=$version/g" ./build
  '';

  buildPhase = ''
    cd go/src/github.com/yggdrasil-network/yggdrasil-go
    ./build
  '';

  installPhase = ''
    mkdir -p $bin/bin
    mv yggdrasil $bin/bin
    mv yggdrasilctl $bin/bin

   echo done
  '';

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://github.com/yggdrasil-network/yggdrasil-go;
    description = "An experiment in scalable routing as an encrypted IPv6 overlay network";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
