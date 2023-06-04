pkgs: {name, dependencies, system ?  "x86_64-linux"}:
let 
src = builtins.readFile (./bin + "/${name}");
  buildInputs = [dependencies];
  script = (pkgs.writeScriptBin name src).overrideAttrs(old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });
in 
  pkgs.symlinkJoin {
    name = name;
    paths = [ script ] ++ buildInputs;
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
  }
