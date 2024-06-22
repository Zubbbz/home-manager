{ config, pkgs, ... }:
let
  myAliases = {
    ll = "ls -aF";
    rebuildsys = "sudo nixos-rebuild switch -I nixos-config=/home/nathan/projects/nixos-config/hosts/thinker/configuration.nix";
    updatehm = "home-manager switch";
    garbcol = "sudo nix-collect-garbage";
    reloadd = "sudo systemctl --user daemon-reload";
    cat = "bat";
  };
  fontFamily = "Sauce Code Pro Nerd Font";
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nathan";
  home.homeDirectory = "/home/nathan";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
                "electron-25.9.0"
              ];

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

    discord
    qbittorrent
    unzip
    xfce.thunar
    neovim
    bitwarden
    bitwarden-cli
    gimp
    ffmpeg
    ffmpegthumbnailer
    flameshot
    ffmpegthumbs
    # rustdesk
    vscodium-fhs
    obs-studio
    obsidian
    mpv
    v2raya
    neofetch
    ripgrep
    thefuck
    alacritty
    prismlauncher
    lf
    nomacs
    darktable
    protonup-qt
    # home-manager
    signal-desktop
    rustup
    gcc
    go
    bat
    libreoffice-still
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
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nathan/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs = {
    zsh = {
      enable = true;
      shellAliases = myAliases;
      initExtra = ''
        if [ -z "$TMUX"]; then
          tmux a
        fi
      '';

      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };

      syntaxHighlighting.enable = true;

      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; }
        ];
      };

    };

    starship = {
      enable = true;
    };

    git = {
      enable = true;
      userName = "Zubbbz";
      userEmail = "37497090+Zubbbz@users.noreply.github.com";
      signing.signByDefault = true;
      signing.key = "/home/nathan/.ssh/keys/Git.pub";
      extraConfig = {
        gpg.format = "ssh";
        init.defaultBranch = "main";
        color.ui = "auto";
        pull.rebase = true;
      };
    };

    ssh = {
      enable = true;
      forwardAgent = true;
      matchBlocks = {
        "github.com" = {
          user = "git";
          identityFile = "/home/nathan/.ssh/keys/Git.pub";
          extraOptions = {
            "PubkeyAuthentication" = "yes";
          };
        };
      };
    };

    alacritty = {
      enable = true;

      settings = {
        shell = "${pkgs.zsh}/bin/zsh";

        window = {
          dimensions = {
            columns = 80;
            lines = 24;
          };
          opacity = 0.8;
          blur = true;
        };

        font = {
          size = 12;

          normal = {
            family = fontFamily;
          };

          bold = {
            family = fontFamily;
          };

          italic = {
            family = fontFamily;
          };

          bold_talic = {
            family = fontFamily;
          };
        };
        
        env = {
          WINIT_X11_SCALE_FACTOR = "1.0";
        };
      };
    };

    librewolf = {
      enable = true;
      package = pkgs.librewolf;

      # about:config changes
      settings = {
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = true;
        "privacy.resistFingerprinting.letterboxing" = true;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.downloads " = false;
        "middlemouse.paste" = false;
        "security.OCSP.require" = false;
        "accessibility.browsewithcaret" = true;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
        "findbar.highlightAll" = true;
        "network.captive-portal-service.enabled" = true;
      };
    };

    tmux = {
      enable = true;
      clock24 = true;
      newSession = true;
      shell = "${pkgs.zsh}/bin/zsh";
    };

  };

  services = {
    easyeffects.enable = true;
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 1800;
    };
  };
}
