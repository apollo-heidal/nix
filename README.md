# nix

nix/
├── flake.nix             # Defines inputs (nixpkgs, home-manager, etc.) and outputs (systems, home configs)
├── flake.lock            # Pins exact versions of inputs (commit this!)
├── README.md             # Crucial: Document your structure, machines, setup steps
├── nixos/                  # NixOS system configurations
│   ├── common/             # Shared NixOS modules/settings across most systems
│   │   ├── base.nix        # Base packages, users, common services (e.g., SSH)
│   │   ├── users.nix       # User definitions (if shared)
│   │   └── ...             # Other shared modules (fonts, themes, etc.)
│   ├── hosts/              # Machine-specific configurations
│   │   ├── desktop-alpha/  # Configuration for 'desktop-alpha'
│   │   │   ├── configuration.nix  # Main NixOS config for this host (imports common + specific)
│   │   │   └── hardware-configuration.nix # Hardware profile (copy from initial NixOS install)
│   │   ├── laptop-beta/    # Configuration for 'laptop-beta'
│   │   │   ├── configuration.nix
│   │   │   └── hardware-configuration.nix
│   │   └── server-gamma/   # Configuration for 'server-gamma'
│   │       ├── configuration.nix
│   │       └── hardware-configuration.nix
│   └── modules/            # Your custom NixOS modules (if complex)
├── home/                   # Home Manager configurations
│   ├── common/             # Shared Home Manager settings/modules
│   │   ├── base.nix        # Common packages (git, htop), basic shell setup
│   │   ├── aliases.nix
│   │   └── ...
│   ├── users/              # User-specific configurations
│   │   ├── alice/          # Config for user 'alice'
│   │   │   ├── home.nix    # Main HM config for alice (imports common + specific)
│   │   │   ├── desktop.nix # Desktop environment specifics
│   │   │   └── cli.nix     # Command-line tools specifics
│   │   └── bob/            # Config for user 'bob'
│   │       └── home.nix
│   └── modules/            # Your custom Home Manager modules
├── pkgs/                   # Your custom packages (defined as flake outputs)
│   └── default.nix
├── secrets/                # Encrypted secret files (see Secrets Management below)
│   ├── secrets.yaml.age
│   └── id_ed25519.age
└── lib/                    # Custom helper functions (optional)
    └── default.nix
