{
  description = "nodejs";

  inputs.nixpkgs.url = "nixpkgs/nixos-21.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
        overlay = (final: prev: {
          nodejsApp = (final.callPackage ./. { } // {
            # server = final.callPackage ./server { };
            frontend = final.callPackage ./. { };
          });
        });

        mergeEnvs = pkgs: envs:
          pkgs.mkShell (builtins.foldl' (a: v: {
            buildInputs = a.buildInputs ++ v.buildInputs;
            nativeBuildInputs = a.nativeBuildInputs ++ v.nativeBuildInputs;
            propagatedBuildInputs = a.propagatedBuildInputs
              ++ v.propagatedBuildInputs;
            propagatedNativeBuildInputs = a.propagatedNativeBuildInputs
              ++ v.propagatedNativeBuildInputs;
            shellHook = a.shellHook + "\n" + v.shellHook;
          }) (pkgs.mkShell { }) envs);

      in rec {
        inherit overlay;
        apps = { dev = pkgs.nodejsApp.dev; };
        defaultApp = apps.dev;
        packages = {
          image = pkgs.nodejsApp.image;
          # server = pkgs.nodejsApp.server.server;
          static = pkgs.nodejsApp.frontend.static;
        };
        defaultPackage = packages.image;
        checks = packages;
        devShell = mergeEnvs pkgs (with devShells; [
          frontend
          # server
        ]);
        devShells = {
          frontend = pkgs.nodejsApp.frontend.shell;
          # server = pkgs.nodejsApp.server.shell;
        };
      });
}
