alias d := debug

# Load flake into repl (look for the `outputs` variable)
debug:
  nix repl --expr 'builtins.getFlake "/etc/nixos"'
