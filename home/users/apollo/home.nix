{ config, pkgs, inputs, hostName, username, ... }: # Note the available specialArgs

{
  # Home Manager needs a state version
  home.stateVersion = "24.11"; # Match your NixOS stateVersion

  # Set username and home directory (redundant but good practice)
  home.username = username; # Uses the username passed from flake.nix
  home.homeDirectory = "/home/${username}";

  # Basic packages
  home.packages = with pkgs; [
    htop
    # Add user-specific packages here
  ];

  # Example: Configure git
  programs.git = {
    enable = true;
    userName = "Apollo"; # Replace with actual name
    userEmail = "apollo@example.com"; # Replace with actual email
  };

  # Enable home-manager command
  programs.home-manager.enable = true;

  # Link user's zsh config if needed, or configure directly
  # programs.zsh = {
  #   enable = true;
  #   ohMyZsh.enable = true;
  #   # dotDir = ".config/oh-my-zsh"; # Example if managing dotfiles elsewhere
  #   # initExtra = ''
  #   #  source ${config.home.homeDirectory}/.zshrc.local # Example
  #   # '';
  # };

  # Link user's neovim config if needed, or configure directly
  # programs.neovim = {
  #   enable = true;
  #   # package = pkgs.neovim-unwrapped; # Example if using a wrapper
  #   # extraConfig = ''
  #   #  lua << EOF
  #   #  require('your-nvim-config')
  #   #  EOF
  #   # '';
  # };

  # Environment variables specific to the user
  # home.sessionVariables = {
  #   EXAMPLE_VAR = "example_value";
  # };
}
