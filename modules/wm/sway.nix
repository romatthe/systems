{ lib, pkgs, ... }:

with lib;
let
  joinWithSep = list: sep: concatStringsSep sep (map toString list);
  toRGB = hex: let
    chars = stringToCharacters hex;
    r = sublist 0 2 chars;
    g = sublist 2 2 chars;
    b = sublist 4 2 chars;
    hexPairToNum = pair: let
      c1 = elemAt pair 0; c2 = elemAt pair 1;
      hexMapping = {
        "A" = 10;
        "B" = 11;
        "C" = 12;
        "D" = 13;
        "E" = 14;
        "F" = 15;
      };
      toNum = c: if hexMapping ? ${toUpper c} then hexMapping.${toUpper c} else toInt c;
    in 16 * (toNum c1) + (toNum c2);
  in [
    (hexPairToNum r)
    (hexPairToNum g)
    (hexPairToNum b)
  ];
  _rgbColor = color: extra: "(" + (joinWithSep ((toRGB color) ++ extra) ", ") + ")";
  rgbaColor = color: _opacity: let
    opacityStr = fixedWidthString 3 "0" (toString _opacity);
    opacity = substring 0 1 opacityStr + "." + substring 1 2 opacityStr;
  in "rgba" + _rgbColor color [opacity];
  hexColor = color: "#" + color;
  hexColor' = color: opacity: "#" + color + toString opacity;
  colors = let
    scaleDef = [ 50 100 200 300 400 500 600 700 800 900 ];
    scale = s: listToAttrs (zipListsWith (variant: color: nameValuePair "_${toString variant}" color) scaleDef s);
  in rec {
    # Default palette
    coolGray = scale [ "F9FAFB" "F3F4F6" "E5E7EB" "D1D5DB" "9CA3AF" "6B7280" "4B5563" "374151" "1F2937" "111827" ];
    red      = scale [ "FEF2F2" "FEE2E2" "FECACA" "FCA5A5" "F87171" "EF4444" "DC2626" "B91C1C" "991B1B" "7F1D1D" ];
    amber    = scale [ "FFFBEB" "FEF3C7" "FDE68A" "FCD34D" "FBBF24" "F59E0B" "D97706" "B45309" "92400E" "78350F" ];
    emerald  = scale [ "ECFDF5" "D1FAE5" "A7F3D0" "6EE7B7" "34D399" "10B981" "059669" "047857" "065F46" "064E3B" ];
    blue     = scale [ "EFF6FF" "DBEAFE" "BFDBFE" "93C5FD" "60A5FA" "3B82F6" "2563EB" "1D4ED8" "1E40AF" "1E3A8A" ];
    indigo   = scale [ "EEF2FF" "E0E7FF" "C7D2FE" "A5B4FC" "818CF8" "6366F1" "4F46E5" "4338CA" "3730A3" "312E81" ];
    violet   = scale [ "F5F3FF" "EDE9FE" "DDD6FE" "C4B5FD" "A78BFA" "8B5CF6" "7C3AED" "6D28D9" "5B21B6" "4C1D95" ];
    pink     = scale [ "FDF2F8" "FCE7F3" "FBCFE8" "F9A8D4" "F472B6" "EC4899" "DB2777" "BE185D" "9D174D" "831843" ];

    # Extra
    blueGray = scale [ "F8FAFC" "F1F5F9" "E2E8F0" "CBD5E1" "94A3B8" "64748B" "475569" "334155" "1E293B" "0F172A" ];

    # Aliases
    gray   = coolGray;
    yellow = amber;
    green = emerald;
    purple = violet;
  };
in {
  services.xserver.enable = true;
  services.xserver.displayManager.defaultSession = "sway";
  services.xserver.displayManager.sessionPackages = [ pkgs.sway ];
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  # Enable to make sure /etc/X11/xkb is populated
  services.xserver.exportConfiguration = true;

  # Enable Vulkan support
  hardware.graphics.enable32Bit = true;

  # # Configuring sway (assuming a display manager starts it)
  # systemd.user.targets.sway-session = {
  #   description = "Sway compositor session";
  #   documentation = [ "man:systemd.special(7)" ];
  #   bindsTo = [ "graphical-session.target" ];
  #   wants = [ "graphical-session-pre.target" ];
  #   after = [ "graphical-session-pre.target" ];
  # };

  # Both may be required for applications that capture desktop output,
  # such as screenshot tools and video conferencing apps
  # xdg.portal.enable = true;
  # xdg.portal.wlr.enable = true;

  xdg.portal = { 
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
    gtkUsePortal = true;
  };

  services.pipewire = { 
    enable = true;
  };  

  # Allow swaylock to unlock the computer for us
  security.pam.services.swaylock = { text = "auth include login"; };

  home-manager.users.romatthe = { pkgs, ... }: {
    # Packages need to properly run Sway
    home.packages = with pkgs; [
      flameshot
      # Basic 
      swaylock
      swayidle
      wl-clipboard
      mako
      # TODO: ulauncher seems very broken on nixos?
      # ulauncher
      wofi
      # waybar

      # For waybar
      pavucontrol
      playerctl

      # Fonts
      apple-otf
      font-awesome

      nwg-launchers

      wlogoutbar
    ];

    programs.mako = {
      enable = true;
      anchor = "top-right";
      layer = "overlay";

      font = "SF Pro Display 12";

      backgroundColor = hexColor colors.gray._200;
      progressColor = "source ${hexColor colors.gray._300}";
      textColor = hexColor colors.gray._700;
      padding = "15,20";
      margin = "0,10,10,0";

      borderSize = 1;
      borderColor = hexColor colors.gray._300;
      borderRadius = 4;

      defaultTimeout = 10000;
      extraConfig = ''
        [urgency=high]
        ignore-timeout=1
        text-color=${hexColor colors.red._900}
        background-color=${hexColor colors.red._200}
        progress-color=source ${hexColor colors.red._300}
        border-color=${hexColor colors.red._300}
      '';
    };

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
        fonts = {
          names = [ "Font Awesome 5 Free" "SF Pro Display" ];
          size = 12.0;
        };
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
          # "1" = [{ app_id = "firefox"; }];
          # "2" = [{ app_id = "Alacritty"; }];
        };
        output = {
          # "*" = {

          # };
          "DP-1" = {
            # bg = "~/wallpaper/wallpaper.jpg fill";
            position = "0,0";
            mode = "3440x1440@100Hz";
          };
          # "HDMI-A-2" = {
          # position = "1920,0";
          # };
        };
        # workspaceOutputAssign = lib.mkIf (hostName == "sirius") [
        workspaceOutputAssign = [
          {
            workspace = "1";
            output = "DP-1";
          }
          {
            workspace = "2";
            output = "DP-1";
          }
          {
            workspace = "3";
            output = "DP-1";
          }
          {
            workspace = "4";
            output = "DP-1";
          }
          {
            workspace = "5";
            output = "DP-1";
          }
          {
            workspace = "6";
            output = "DP-1";
          }
          {
            workspace = "7";
            output = "DP-1";
          }
          {
            workspace = "8";
            output = "DP-1";
          }
          {
            workspace = "9";
            output = "DP-1";
          }
          {
            workspace = "0";
            output = "DP-1";
          }
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

    programs.waybar = let
      battery = { name }: {
        bat = name;
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
        format-charging = "{capacity}% ";
        format-plugged = "{capacity}% ";
        format-alt = "{time} {icon}";
        format-icons = [ "" "" "" "" "" ];
      };
      # media = { number } : {
      #   format = "{icon} {}";
      #   return-type = "json";
      #   max-length = 55;
      #   format-icons = {
      #     Playing = "";
      #     Paused = "";
      #   };
      #   exec = "mediaplayer ${toString number}";
      #   exec-if = "[ $(playerctl -l 2>/dev/null | wc -l) -ge ${toString (number + 1)} ]";
      #   interval = 1;
      #   on-click = "play-pause ${toString number}";
      # };
    in {
      enable = true;
      package = pkgs.waybar.override { pulseSupport = true; };
      settings = [{
        height = 40;
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right = [
          "tray"
          "pulseaudio"
          "network"
          "memory"
          "cpu"
          # "backlight"
          # "battery#bat0"
          # "battery#bat1"
          "clock"
          "custom/power"
        ];
        modules = {
          "sway/workspaces" = {
            all-outputs = true;
            format = "{icon}";
            format-icons = {
              "1" = "";
              "2" = "";
              "3" = "";
              "4" = "";
              "5" = "";
              "6" = "";
              "7" = "";
              "9" = "";
              "10" = "";
              focused = "";
              urgent = "";
              default = "";
            };
          };
          "sway/window" = {
            format = "{}";
            max-length = 50;
            # rewrite = {
            #   "(.*) - Mozilla Firefox" = "🌎 $1";
            #   "(.*) - vim" = " $1";
            #   "(.*) - zsh" = " [$1]";
            # };
          };
          tray = { spacing = 10; };
          clock = {
            tooltip-format = ''
              <big>{:%Y %B}</big>
              <tt><small>{calendar}</small></tt>'';
            format-alt = "{:%A, %d %b}";
          };
          cpu = { format = "{usage}% "; };
          memory = { format = "{}% "; };
          # backlight = {
          #   format = "{icon}";
          #   format-alt = "{percent}% {icon}";
          #   format-alt-click = "click-right";
          #   format-icons = [ "○" "◐" "●" ];
          #   on-scroll-down = "light -U 10";
          #   on-scroll-up = "light -A 10";
          # };
          # "battery#bat0" = battery { name = "BAT0"; };
          # "battery#bat1" = battery { name = "BAT1"; };
          network = {
            format-wifi = "{essid} ({signalStrength}%) ";
            format-ethernet = "Ethernet ";
            format-linked = "Ethernet (No IP) ";
            format-disconnected = "Disconnected ";
            format-alt = "{bandwidthDownBits}/{bandwidthUpBits}";
            on-click-middle = "nm-connection-editor";
          };
          pulseaudio = {
            scroll-step = 1;
            format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-muted = " {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [ "" "" "" ];
            };
            on-click = "pavucontrol";
          };
          # "custom/media#0" = mkIf audioSupport (media { number = 0; });
          # "custom/media#1" = mkIf audioSupport (media { number = 1; });
          "custom/power" = {
            format = "";
            on-click = "wlogoutbar -lcc swaylock -p center";
            escape = true;
            tooltip = false;
          };
        };
      }];
      style = ''
        * {
          border: none;
          border-radius: 0;
          font-size: 13px;
          font-family: "SF Pro Display", "Font Awesome 5 Free";
        }

        window#waybar {
          background-color: rgba(0,0,0,0);
        }

        window#waybar.hidden {
          opacity: 0.2;
        }

        #waybar > .horizontal {
          padding: 10px 10px 0;
        }

        #waybar > .horizontal > .horizontal:nth-child(1) {
          margin-right: 10px;
        }

        #workspaces button {
          margin: 10px 0 0 10px;
          font-size: 16px;
          padding: 7px 10px;
          border-radius: 5px;
        }

        #workspaces button:hover {
          box-shadow: inherit;
          text-shadow: inherit;
        }

        #mode {
          margin: 10px 0 0 10px;
          padding: 0 10px;
          border-radius: 5px;
        }

        #window {
          font-weight: 600;
          margin: 10px 0 0 10px;
        }

        #tray,
        #pulseaudio,
        #network,
        #memory,
        #cpu,
        #backlight,
        #battery,
        #clock,
        #custom-media,
        #custom-power {
          margin: 10px 10px 0 0;
          padding: 7px 15px;
          border-radius: 5px;
        }

        #backlight {
          font-size: 15px;
        }
        #custom-media {
          min-width: 100px;
          margin: 10px 0 0 10px;
        }

        #custom-media:nth-child(2) {
          margin-right: 10px;
        }

        /* Colors */
        /* Base */
        #workspaces button,
        #mode,
        #window
        #tray,
        #pulseaudio,
        #network,
        #memory,
        #cpu,
        #backlight,
        #battery,
        #clock,
        #custom-media,
        #custom-power {
            background: ${rgbaColor colors.gray._200 90};
            color: ${hexColor colors.gray._700};
        }
        /* Effects */
        #workspaces button:hover {
            background: ${rgbaColor colors.gray._200 40};
        }
        #workspaces button.focused {
            background: ${rgbaColor colors.gray._300 100};
            color: ${hexColor colors.gray._800};
        }
        /* Disabled */
        #network.disconnected,
        #pulseaudio.muted,
        #custom-nordvpn.disconnected {
            background: ${rgbaColor colors.gray._200 50};
            color: ${hexColor colors.gray._400};
        }
        /* Green */
        #battery.charging {
            background: ${rgbaColor colors.green._200 60};
            color: ${hexColor colors.green._900};
        }
        /* Urgent */
        #workspaces button.urgent,
        #battery.critical:not(.charging) {
            background: ${rgbaColor colors.red._200 90};
            color: ${hexColor colors.red._900};
        }
        /* Tooltip */
        tooltip {
            background: ${rgbaColor colors.gray._200 90};
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }

        tooltip * {
            color: ${hexColor colors.gray._700};
        }
      '';
    };
  };
}
