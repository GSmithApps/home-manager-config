{
  description = "Home Manager configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        defaultPackage = home-manager.defaultPackage.${system};
        homeConfigurations.grants = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            {
              home = {
                username = "grants";
                homeDirectory = "/home/grants";
                stateVersion = "24.05";
                packages = with pkgs; [
                  # # You can also create simple shell scripts directly inside your
                  # # configuration. For example, this adds a command 'my-hello' to your
                  # # environment:
                  # (pkgs.writeShellScriptBin "my-hello" ''
                  #   echo "Hello, ${config.home.username}!"
                  # '')
                  lazygit
                  fira-code-nerdfont
                  obsidian
                  pdfarranger
                  qpdf
                  wl-clipboard
                  #nvchad
                  ripgrep
                  gcc13
                  gnumake
                  #java
                    # zulu17
                  (vscode-with-extensions.override {
                    vscodeExtensions = with vscode-extensions; [
                      jnoortheen.nix-ide
                      eamodio.gitlens
                      mhutchie.git-graph
                      mechatroner.rainbow-csv
                      hediet.vscode-drawio

                      # java things
                        # vscjava.vscode-java-pack
                        # vscjava.vscode-gradle
                        # redhat.java
                        # vscjava.vscode-java-test
                        # vscjava.vscode-java-debug
                        # vscjava.vscode-spring-initializr
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
                      # sha256 = "sha256-d0c602f5f155d4d1261609219e9b8a61e936d681";
                      # sha256 = lib.fakeSha256;
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
              nixpkgs.config.allowUnfree = true;
              programs = {

                # Let Home Manager install and manage itself.
                home-manager = {
                  enable = true;
                };

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

                tmux = {
                  enable = true;
                };

                neovim = {
                  enable = true;
                };
              };
            }
          ];
        };
      }
    );
}
