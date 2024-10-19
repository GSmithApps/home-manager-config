{ pkgs, ... }:

{
  home = {
    username = "grants";
    homeDirectory = "/home/grants";
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.05"; # Please read the comment before changing.
    packages = with pkgs; [
      lazygit
      cargo
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
        vscodeExtensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          eamodio.gitlens
          mhutchie.git-graph
          mechatroner.rainbow-csv
          hediet.vscode-drawio
          rust-lang.rust-analyzer

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