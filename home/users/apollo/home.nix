{ config, pkgs, inputs, hostName, username, ... }: { # Note the available specialArgs
  # Home Manager needs a state version
  home.stateVersion = "24.11"; # Match your NixOS stateVersion

  # Set username and home directory (redundant but good practice)
  home.username = username; # Uses the username passed from flake.nix
  home.homeDirectory = "/home/${username}";

  # Basic packages
  home.packages = with pkgs; [
    htop
    # Language servers for Neovim completions
    lua-language-server # Lua LSP
    nixd # Nix LSP
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

  # Configure Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true; # Enable zsh's completion system
    autosuggestion.enable = true; # Enable fish-like autosuggestions
    syntaxHighlighting.enable = true; # Enable syntax highlighting
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "docker" "docker-compose" ]; # Add plugins for completions
      # theme = "robbyrussell"; # Set your preferred theme
    };
  #   # dotDir = ".config/oh-my-zsh"; # Example if managing dotfiles elsewhere
  #   # initExtra = ''
  #   #  source ${config.home.homeDirectory}/.zshrc.local # Example
  #   # '';
  # };

  # Configure Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true; # Sets $EDITOR, $VISUAL
    # package = pkgs.neovim-unwrapped; # Use if you need a specific neovim package
    # extraConfig = ''
    #   " Basic settings can go here
    #   set number relativenumber
    #   set tabstop=2 shiftwidth=2 expandtab

    #   " Example for LSP/completion setup (requires plugins like nvim-lspconfig, nvim-cmp)
    #   lua << EOF
    #   -- require('lspconfig').lua_ls.setup{}
    #   -- require('lspconfig').nixd.setup{}
    #   -- require('cmp').setup{ ... } -- Requires nvim-cmp setup
    #   EOF
    # '';
    # plugins = with pkgs.vimPlugins; [
    #   nvim-lspconfig # LSP configuration helper
    #   nvim-cmp # Completion engine
    #   cmp-nvim-lsp # LSP source for nvim-cmp
    #   cmp-buffer # Buffer source for nvim-cmp
    #   cmp-path # Path source for nvim-cmp
    #   -- Add other plugins here
    # ];
  };

  # Environment variables specific to the user
  # home.sessionVariables = {
  #   EXAMPLE_VAR = "example_value";
  # };
}
