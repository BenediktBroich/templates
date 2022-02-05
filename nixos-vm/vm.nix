{ pkgs, ... }: {

  # enable nix flakes
  # Source: https://nixos.wiki/wiki/Flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';

  # enable direnv
  # Source: https://github.com/nix-community/nix-direnv
  environment.systemPackages = with pkgs; [ direnv nix-direnv ];
  environment.pathsToLink = [ "/share/nix-direnv" ];
  nixpkgs.overlays = [ (self: super: { nix-direnv = super.nix-direnv.override { enableFlakes = true; }; } ) ];

  # Source: https://github.com/Mic92/nixos-shell
  boot.kernelPackages = pkgs.linuxPackages_latest;

  virtualisation.cores = 2;
  virtualisation.memorySize = 1024;

  # Services
  # https://search.nixos.org/options
  # nixos-option

  programs.git.enable = true;
}
