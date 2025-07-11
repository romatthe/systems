{ nixpkgs, pkgs, ... }:
let
  amdgpu_top = pkgs.amdgpu_top.overrideAttrs (old: {
    postInstall = old.postInstall + ''
      substituteInPlace $out/share/applications/amdgpu_top.desktop \
        --replace "Name=AMDGPU TOP (GUI)" "Name=AMDGPU TOP"
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
  steam-unwrapped' = pkgs.steam-unwrapped.overrideAttrs (old: {
    postInstall = old.postInstall + ''  
      substituteInPlace $out/share/applications/steam.desktop \
        --replace "Exec=steam %U" "Exec=sh -c '${pkgs.steam-cleaner}/bin/steam-cleaner; steam %U'"
    '';
  });
  steamtinkerlaunch = pkgs.steamtinkerlaunch.overrideAttrs (old: {
    # Prepare the proper files for the steam compatibility toolchain
    postInstall = old.postInstall + ''
      mkdir -p $out/share/Steam/compatibilitytools.d/steamtinkerlaunch
      ln -s $out/bin/steamtinkerlaunch $out/share/Steam/compatibilitytools.d/steamtinkerlaunch/steamtinkerlaunch

      cat > $out/share/Steam/compatibilitytools.d/steamtinkerlaunch/compatibilitytool.vdf << EOF
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

      cat > $out/share/Steam/compatibilitytools.d/steamtinkerlaunch/toolmanifest.vdf << EOF
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
    package = pkgs.steam.override {
      steam-unwrapped = steam-unwrapped'; # Steam with desktop instructions to launch Steam-Metadata-Editor first
      extraPkgs = pkgs: with pkgs; [ 
         # Fix for native version of CKIII
        ncurses6
        
        # Potential fix for runnings games within Gamescope from inside Steam
        # See: https://github.com/NixOS/nixpkgs/issues/162562#issuecomment-1523177264
        libkrb5
        keyutils 
      ];
    }; 
  };

  # Make the latest version of steamtinkerlauncher available in Steam by adding it to
  # compat tools env variable
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${STEAM_EXTRA_COMPAT_TOOLS_PATHS}:${steamtinkerlaunch}/share/Steam/compatibilitytools.d/steamtinkerlaunch";
    # STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${STEAM_EXTRA_COMPAT_TOOLS_PATHS}:${steamtinkerlaunch}/share/Steam/compatibilitytools.d/steamtinkerlaunch:${pkgs.luxtorpeda}/share/Steam/compatibilitytools.d/luxtorpeda";
    # STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${steamtinkerlaunch}/share/Steam/compatibilitytools.d/steamtinkerlaunch:${pkgs.luxtorpeda}/share/Steam/compatibilitytools.d/luxtorpeda";
    # STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${pkgs.luxtorpeda}/share/Steam/compatibilitytools.d/luxtorpeda:${steamtinkerlaunch}/share/Steam/compatibilitytools.d/steamtinkerlaunch";
  };

  environment.systemPackages = with pkgs; [
    # Clients
    bottles
    heroic
    lutris
    minigalaxy
    prismlauncher
    unstable.umu-launcher

    # Steam    
    # steamtinkerlaunch # Patched to better work with the Steam compat tools
    # luxtorpeda

    # Commercial games
    # unstable.minecraft # Prism Launcher doesn't work at the moment so we're back on the classic launcher, TODO reanable
    unstable.starsector
    #unstable.vintagestory
    insecure.vintagestory # TODO: VS has to move to supported runtime
    
    # Commercial dosbox games
    # dosbox-mmwox

    # Open source games and engines
    airshipper      # Veloren launcher
    # ambermoon-net # TODO: Move to .NET 8
    arx-libertatis  # Arx Fatalis source port
    dhewm3
    exult           # Ultima VII engine
    fheroes2        # Heroes of Might and Magic II engine
    gemrb           # Infinity Engine
    gzdoom
    iortcw          # Return to Castle Wolfenstein
    openmw          # Morrowind engine 
    openttd
    openxcom        # X-COM engine
    rbdoom-3-bfg
    rotp            # Remnants of the Precursors
    runelite        # Runescape client
    scummvm
    shipwright      # Oracina of Time reverse engineered
    uqm             # The Ur-Quan Masters
    vcmi            # Heroes of Might and Magic III engine
    vkquake
    wargus          # Open source Warcraft II engine on top of Stratagus engine
    wesnoth         # Battle for Wesnoth
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
    gamemode
    gamescope
    libstrangle # Linux OpenGL/Vulkan frame limiter
    
    mangohud
    opentrack
    protonup
    samrewritten
    steam-cleaner
    steam-metadata-editor
    vkbasalt
    vkbasalt-cli
    vulkan-tools

    unstable.protontricks
    unstable.winetricks
    
    # Gameplay recording
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        obs-vaapi
        obs-vkcapture
      ];
    })
    gpu-screen-recorder
    gpu-screen-recorder-gtk

    # GPU monitoring and control
    amdgpu_top
    corectrl
    glances
    lact
    nvtopPackages.full
  ];
}
