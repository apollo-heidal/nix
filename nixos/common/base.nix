# Common NixOS configuration settings shared across hosts
{ config, lib, pkgs, ... }:

{
  # --- Nix Settings ---
  # Enable flakes and nix command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Automatically optimise the Nix store
  nix.settings.auto-optimise-store = true;
  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # --- Localization ---
  # Set your time zone.
  time.timeZone = "Etc/UTC"; # IMPORTANT: Change this to your actual time zone! e.g., "America/New_York"

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    # useXkbConfig = true; # use xkb.options in tty. (optional)
  };

  # --- Networking ---
  # Enable NetworkManager for easier network configuration
  networking.networkmanager.enable = true;
  # Disable wireless by default (can be enabled per-host)
  networking.wireless.enable = false;
  # Set a default hostname (will be overridden by host-specific config)
  # networking.hostName = "nixos"; # REMOVED: Hostname should be set in host-specific config

  # --- Services ---
  # Enable the OpenSSH daemon for remote access.
  services.openssh = {
    enable = true;
    settings = {
      # Disallow password authentication by default for security. Use SSH keys.
      PasswordAuthentication = false;
      PermitRootLogin = "no"; # Disallow root login
    };
  };

  # --- Users ---
  # Set Zsh as the default shell for users
  users.defaultUserShell = pkgs.zsh;

  # --- Programs ---
  # Enable Zsh system-wide settings (needed if users.defaultUserShell is zsh)
  programs.zsh.enable = true;

  # --- Packages ---
  # Install some common utility packages system-wide
  environment.systemPackages = with pkgs; [
    wget # Network downloader
    curl # Network utility
    git # Version control
    vim # Basic text editor
    htop # Process viewer
    tree # Directory listing utility
    unzip # For extracting zip files
  ];

  # --- System ---
  # This option defines the NixOS version the system was originally installed with.
  # It's crucial for maintaining compatibility.
  # IMPORTANT: You MUST set this to the version you actually installed.
  # Check your host configurations to ensure consistency.
  system.stateVersion = "24.11"; # Set based on your other files, VERIFY THIS!

  # --- Nixpkgs Configuration ---
  # Allow unfree packages if needed (e.g., drivers, specific software)
  # Set to true if you install packages like nvidia drivers, discord, etc.
  nixpkgs.config.allowUnfree = false; # Default is false (recommended)

}
