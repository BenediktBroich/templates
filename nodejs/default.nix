{ stdenv, callPackage, nodejs, nodePackages, writeShellScriptBin }:
let
  generated = callPackage ./nix { inherit nodejs; };

  node2nix = writeShellScriptBin "node2nix" ''
    ${nodePackages.node2nix}/bin/node2nix \
      --development \
      -c ./nix/default.nix \
      -o ./nix/node-packages.nix \
      -e ./nix/node-env.nix
  '';
in {
  inherit (generated) nodeDependencies;
  static = stdenv.mkDerivation {
    name = "nodejs-frontend";
    src = ./.;
    buildInputs = [ nodejs node2nix];
    buildPhase = ''
      ln -s ${generated.nodeDependencies}/lib/node_modules ./node_modules
      export PATH="${generated.nodeDependencies}/bin:$PATH"
      npm run build
    '';
    installPhase = ''
      cp -r dist $out/
    '';
  };
  shell = generated.shell.override {
    buildInputs = [ node2nix ];
  };
}
