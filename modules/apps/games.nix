{ nixpkgs, pkgs, ... }:
let
  amdgpu_top = pkgs.amdgpu_top.overrideAttrs (old: {
    postInstall = old.postInstall + ''
      substituteInPlace $out/share/applications/amdgpu_top.desktop \
        --replace "Name=AMDGPU TOP (GUI)" "Name=AMDGPU TOP"
    '';
  });
  heroic = pkgs.unstable.heroic.overrideAttrs (old: {
    buildCommand = old.buildCommand + ''
      rm $out/share/applications $out/share/icons
      mkdir -p $out/share/applications $out/share/icons/hicolor/128x128/apps

      cp "${pkgs.heroic-unwrapped}/share/${old.pname}/flatpak/com.heroicgameslauncher.hgl.desktop" "$out/share/applications"
      cp "${pkgs.heroic-unwrapped}/share/${old.pname}/flatpak/com.heroicgameslauncher.hgl.png" "$out/share/icons/hicolor/128x128/apps"
    '';
  });
  starsector = pkgs.unstable.starsector.overrideAttrs (old: {
    postInstall = old.postInstall + ''
      # Delete the symlink
      rm $out/share/icons/hicolor/64x64/apps/starsector.png

      # Copy the actual PNG
      cp $out/graphics/ui/s_icon64.png \ 
        $out/share/icons/hicolor/64x64/apps/starsector.png $out/graphics/ui/s_icon64.png
    '';
  });
  steamtinkerlaunch = pkgs.steamtinkerlaunch.overrideAttrs (old: {
    version = old.version + "-patched";
    # Prepare the proper files for the steam compatibility toolchain
    postInstall = old.postInstall + ''
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
    package = pkgs.steam.override {
      extraPkgs = pkgs: [ pkgs.ncurses6 ]; # Fix for native version of CKIII
    };
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
    #luxtorpeda

    # Commercial games
    unstable.minecraft # Prism Launcher doesn't work at the moment so we're back on the classic launcher
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
    scummvm
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
    steam-metadata-editor
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
    amdgpu_top
    corectrl
    lact
    nvtop
  ];
}
