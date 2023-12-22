{
  filePath,
  dependencies,
  system,
  lib,
  writeScriptBin,
  runCommand,
  makeWrapper,
  ...
}:
let
  name = baseNameOf filePath;
in
runCommand "${name}-wrapped" { nativeBuildInputs = [makeWrapper]; } ''
  script=$out/bin/${name}
  install -Dm 0755 ${filePath} $script
  patchShebangs $script
  wrapProgram $script --set PATH ${lib.makeBinPath dependencies}
''
