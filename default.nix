{ lib, stdenv, swift, swiftpm, swiftpm2nix, help2man, gnused, date ? null, ... }:

let
  generated = swiftpm2nix.helpers ./nix;
in

stdenv.mkDerivation {
  pname = "SimpleSwiftServer";
  version = "4.4.0";

  src = ./.;

  nativeBuildInputs = [ swift swiftpm ];

  postBuild = ''
    echo "[AUTHOR]

    @Samasaur1 on GitHub" > author.inc
    ${lib.getExe help2man} -i author.inc -o server.1 -N "$(swiftpmBinPath)/server"

    ${lib.optionalString (date != null) ''
      ${lib.getExe gnused} -i"" -e "s/January 1980/${date}/" server.1
    ''}
  '';

  configurePhase = generated.configure;

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1

    binPath="$(swiftpmBinPath)"
    cp $binPath/server $out/bin/

    cp server.1 $out/share/man/man1/
  '';
  
  meta = with lib; {
    platforms = platforms.darwin;
    mainProgram = "server";
  };
}
