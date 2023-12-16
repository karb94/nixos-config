{
  filePath,
  dependencies,
  system,
  lib,
  writeScriptBin,
  runCommand,
  makeWrapper,
  ...
}: let
  src = builtins.readFile filePath;
  name = baseNameOf filePath;
  pathEnvVar = lib.makeBinPath dependencies;
  script = (writeScriptBin name src).overrideAttrs (old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });
  scriptBin = "${script}/bin/${name}";
  command = "makeWrapper ${scriptBin} $out/bin/${name} --set PATH ${pathEnvVar}";
in
  runCommand "${name}-wrapped" { buildInputs = [makeWrapper]; } command
