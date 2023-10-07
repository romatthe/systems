{ nixpkgs, pkgs, ... }:
let 
  steamtinkerlaunch = pkgs.steamtinkerlaunch.overrideAttrs (attrs: {
    version = pkgs.steamtinkerlaunch.version + "-patched";
    # Prepare the proper files for the steam compatibility toolchain
    postInstall = pkgs.steamtinkerlaunch.postInstall + ''
      mkdir -p $out/share/Steam/compatibilitytools.d/SteamTinkerLaunch
      ln -s $out/bin/steamtinkerlaunch $out/share/Steam/compatibilitytools.d/SteamTinkerLaunch/steamtinkerlaunch

      cat > $out/share/Steam/compatibilitytools.d/SteamTinkerLaunch/compatibilitytool.vdf << EOF
      "compatibilitytools"
      {
        "compat_tools"
        {
          "Proton-stl" // Internal name of this tool
          {
            "install_path" "."
            "display_name" "Steam Tinker Launch"

            "from_oslist"  "windows"
            "to_oslist"    "linux"
          }
        }
      }
      EOF

      cat > $out/share/Steam/compatibilitytools.d/SteamTinkerLaunch/toolmanifest.vdf << EOF
      "manifest"
      {
        "commandline" "/steamtinkerlaunch run"
        "commandline_waitforexitandrun" "/steamtinkerlaunch waitforexitandrun"
      }
      EOF
    '';
  });
in {
  programs.steam = {
    enable = true;
    # package = pkgs.unstable.steam;
    # extraCompatPackages = with pkgs; [
      # luxtorpeda
    # ];
  };

  # Make the latest version of steamtinkerlauncher available in Steam by adding it to
  # compat tools env variable
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${STEAM_EXTRA_COMPAT_TOOLS_PATHS}:${steamtinkerlaunch}/share/Steam/compatibilitytools.d/SteamTinkerLaunch";
  };

  environment.systemPackages = with pkgs; [
    # Clients
    bottles
    heroic
    lutris
    minigalaxy
    prismlauncher

    # Steam    
    # steam
    steamtinkerlaunch # Patched to better work with the Steam compat tools
    luxtorpeda

    # Commercial games
    unstable.starsector
    unstable.vintagestory

    # Open source games and engines
    airshipper  # Veloren launcher
    dhewm3
    exult       # Ultima VII engine
    fheroes2    # Heroes of Might and Magic II engine
    gemrb       # Infinity Engine
    gzdoom
    iortcw
    # nuvie       # Ultima VI engine
    openmw      # Morrowind engine 
    openttd
    openxcom    # X-Com engine
    rbdoom-3-bfg
    runelite    # Runescape client
    unstable.scummvm
    uqm         # The Ur-Quan Masters
    vcmi        # Heroes of Might and Magic III engine
    vkquake
    wesnoth
    widelands
    yquake2
    yquake2-ground-zero
    yquake2-the-reckoning

    # Roguelikes
    angband
    brogue
    cataclysm-dda
    crawl
    ivan

    # Dwarf Fotress
    # See https://github.com/NixOS/nixpkgs/blob/master/pkgs/games/dwarf-fortress/default.nix for more information
    (pkgs.dwarf-fortress-packages.dwarf-fortress-full.override {
      dfVersion = "0.47.04";
      theme = "vettlingr";
      enableDFHack = true;
      enableTWBT = true;
      enableSoundSense = false;
      enableStoneSense = true;
      enableDwarfTherapist = true;
      enableLegendsBrowser = true;
      enableIntro = true;
      enableFPS = true;
    })

    # Tools
    fluidsynth  # For games requiring MIDI playback
    glxinfo
    handbrake   # For gameplay videos
    gamemode
    gamescope
    libstrangle # Linux OpenGL/Vulkan frame limiter
    mame.tools  # Primarily for chdman
    mangohud
    opentrack
    protonup
    protontricks
    samrewritten
    vkbasalt
    vkbasalt-cli
    vulkan-tools
    winetricks

    # OBS plus plugins
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        obs-gstreamer
        obs-vkcapture
      ];
    })

    # GPU monitoring and control
    corectrl
    nvtop
    psensor
    radeon-profile
    radeontop
  ];
}
