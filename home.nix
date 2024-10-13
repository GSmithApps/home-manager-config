{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "grants";
  home.homeDirectory = "/home/grants";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
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
      zulu17
    (pkgs.vscode-with-extensions.override {
      vscodeExtensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        eamodio.gitlens
        mhutchie.git-graph
        mechatroner.rainbow-csv
        hediet.vscode-drawio

        # java things
          vscjava.vscode-java-pack
          vscjava.vscode-gradle
          redhat.java
          vscjava.vscode-java-test
          vscjava.vscode-java-debug
          vscjava.vscode-spring-initializr
      ];
    })
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/grants/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;
  
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = ["git"];
    };
  };
  
  programs.git = {
    enable = true;
    userName = "GSmithApps";
    userEmail = "14.gsmith.14@gmail.com";
  };

  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.98";
      font_family = "FiraCode Nerd font";
      font_size = 17;
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = 0.98;
      font.normal.family = "FiraCode Nerd font";
      font.size = 20;
    };
  };

  programs.tmux = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
  };
  
}
