{
  description = "Home Manager configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
    in {
      homeConfigurations = {
        grants = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            {
              nixpkgs.config.allowUnfree = true;
              home = {
                username = "grants";
                homeDirectory = "/home/grants";
                stateVersion = "24.05";
                packages = with pkgs; [
                  lazygit
                  fira-code-nerdfont
                  obsidian
                  pdfarranger
                  qpdf
                  wl-clipboard
                  ripgrep
                  gcc13
                  gnumake
                  (vscode-with-extensions.override {
                    vscodeExtensions = with pkgs.vscode-extensions; [
                      jnoortheen.nix-ide
                      eamodio.gitlens
                      mhutchie.git-graph
                      mechatroner.rainbow-csv
                      hediet.vscode-drawio
                    ];
                  })
                ];

                file = {
                  ".config/Code/User/settings.json".text = builtins.readFile ./vscode.json;

                  ".config/nvim" = {
                    source = pkgs.fetchFromGitHub {
                      owner = "NvChad";
                      repo = "starter";
                      rev = "main";
                      sha256 = "sha256-SVpep7lVX0isYsUtscvgA7Ga3YXt/2jwQQCYkYadjiM";
                    };
                    recursive = true;
                  };
                };

                sessionVariables = {
                  EDITOR = "nvim";
                  DIRENV_LOG_FORMAT="";
                };
              };
              programs = {
                home-manager.enable = true;

                zsh = {
                  enable = true;
                  oh-my-zsh = {
                    enable = true;
                    theme = "agnoster";
                    plugins = [
                      "git"
                      "direnv"
                    ];
                  };
                };

                git = {
                  enable = true;
                  userName = "GSmithApps";
                  userEmail = "14.gsmith.14@gmail.com";
                };

                kitty = {
                  enable = true;
                  settings = {
                    background_opacity = "0.98";
                    font_family = "FiraCode Nerd font";
                    font_size = 17;
                  };
                };

                direnv = {
                  enable = true;
                  enableZshIntegration = true;
                  nix-direnv.enable = true;
                };

                alacritty = {
                  enable = true;
                  settings = {
                    window.opacity = 0.98;
                    font.normal.family = "FiraCode Nerd font";
                    font.size = 20;
                  };
                };

                tmux.enable = true;
                neovim.enable = true;
              };
            }
          ];
        };
      };
    };
}