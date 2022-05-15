{ lib, pkgs, ... }:
{
  services.xserver.enable = true;
  services.xserver.displayManager.defaultSession = "sway";
  services.xserver.displayManager.sessionPackages = [ pkgs.sway ];
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  # Enable to make sure /etc/X11/xkb is populated
  services.xserver.exportConfiguration = true;

  # Enable Vulkan support
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  # # Configuring sway (assuming a display manager starts it)
  # systemd.user.targets.sway-session = {
  #   description = "Sway compositor session";
  #   documentation = [ "man:systemd.special(7)" ];
  #   bindsTo = [ "graphical-session.target" ];
  #   wants = [ "graphical-session-pre.target" ];
  #   after = [ "graphical-session-pre.target" ];
  # };

  # Allow swaylock to unlock the computer for us
  security.pam.services.swaylock = {
    text = "auth include login";
  };

  home-manager.users.romatthe = { pkgs, ... }: {
    # Packages need to properly run Sway
    home.packages = with pkgs; [
      # Basic 
      swaylock
      swayidle
      wl-clipboard
      mako
      # TODO: ulauncher seems very broken on nixos?
      # ulauncher
      wofi
      waybar
    ];

    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      config = {
        # assigns = let
        #   assign = n: id: { "${toString n}" = [id]; };
        # in
        #   assign 1 { app_id = "firefox"; } //
        #   assign 2 { app_id = "Alacritty"; };
        bars = [{ command = "waybar"; }];
        menu = "wofi --show drun";
        terminal = "alacritty";
        modifier = "Mod4";
        gaps.inner = 20;
        input."type:keyboard" = {
          xkb_layout = "us";
          # xkb_options = "grp:alt_caps_toggle";
          xkb_numlock = "enabled";
        };

        keybindings = lib.mkOptionDefault {
          # Lock
          "Ctrl+Mod4+l" = "exec swaylock";
        };

        assigns = {
          "1" = [ { app_id = "firefox"; } ];
          "2" = [ { app_id = "Alacritty"; } ];
        };
        output = {
          # "*" = {
# 
          # };
          "DP-1" = {
            # bg = "~/wallpaper/wallpaper.jpg fill";
            position = "0,0";
            # mode = "1920x1080@75Hz";
            mode = "3440x1440@100Hz";
          };
          # "HDMI-A-2" = {
            # position = "1920,0";
          # };
        };
        # workspaceOutputAssign = lib.mkIf (hostName == "sirius") [
        workspaceOutputAssign = [
          { workspace = "1"; output = "DP-1"; }
          { workspace = "2"; output = "DP-1"; }
          { workspace = "3"; output = "DP-1"; }
          { workspace = "4"; output = "DP-1"; }
          { workspace = "5"; output = "DP-1"; }
          { workspace = "6"; output = "DP-1"; }
          { workspace = "7"; output = "DP-1"; }
          { workspace = "8"; output = "DP-1"; }
          { workspace = "9"; output = "DP-1"; }
          { workspace = "0"; output = "DP-1"; }
        ];
          # TODO: Set wallpaper here
          # output."*" = { bg = "${cfg.wallpaper} fill"; };
      };
      # extraConfig = ''
        # seat seat0 xcursor_theme "${config.modules.desktop.gtk.cursorTheme.name}" ${toString config.modules.desktop.gtk.cursorTheme.size}
      # '';
      extraSessionCommands = ''
        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=sway
        export XDG_CURRENT_DESKTOP=sway
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
      '';
    };
  };

  # Configuring kanshi
  # systemd.user.services.kanshi = {
  #   description = "Kanshi output autoconfig ";
  #   wantedBy = [ "graphical-session.target" ];
  #   partOf = [ "graphical-session.target" ];
  #   # kanshi doesn't have an option to specifiy config file yet, so it looks
  #   # at ~/.config/kanshi/config
  #   environment = { XDG_CONFIG_HOME="/home/romatthe/.config"; };
  #   serviceConfig = {
  #     ExecStart = ''
  #       ${pkgs.kanshi}/bin/kanshi
  #     '';
  #     RestartSec = 5;
  #     Restart = "always";
  #   };
  # };
}
