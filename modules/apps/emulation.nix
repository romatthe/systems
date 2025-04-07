{ pkgs, ... }:
let
  retroarch = (pkgs.unstable.retroarch.withCores (cores: with cores; [
    beetle-pcfx
    beetle-psx
    beetle-psx-hw
    beetle-saturn
    beetle-supergrafx
    bsnes
    desmume
    dosbox-pure
    flycast
    gambatte
    genesis-plus-gx
    melonds
    mesen
    mgba
    mupen64plus
    neocd
    np2kai
    pcsx2
    ppsspp
    sameboy
    snes9x
    swanstation
  ]));
  # ryubing = pkgs.unstable.ryubing.overrideAttrs (old: {
  #   postFixup = ''
  #     mv $out/share/mime/packages/Ryujinx.xml $out/share/mime/packages/Ryubing.xml
  #     mv $out/share/applications/Ryujinx.desktop $out/share/applications/Ryubing.desktop
  #     mv $out/share/icons/hicolor/scalable/apps/Ryujinx.svg $out/share/icons/hicolor/scalable/apps/Ryubing.svg
  #     mv $out/bin/Ryujinx.sh $out/bin/Ryubing.sh
  #     mv $out/bin/Ryujinx $out/bin/Ryubing

  #     substituteInPlace $out/share/applications/Ryubing.desktop \
  #       --replace "=Ryujinx" "=Ryubing"
      
  #     substituteInPlace $out/bin/Ryubing.sh \
  #       --replace "$SCRIPT_DIR/Ryujinx" "$SCRIPT_DIR/Ryubing"

  #     substituteInPlace $out/bin/Ryubing.sh \
  #       --replace 'RYUJINX_BIN="Ryujinx"' 'RYUJINX_BIN="Ryubing"'

  #     rm $out/bin/ryujinx
  #     ln -s $out/bin/Ryubing $out/bin/ryubing
  #   '';
  # });
in {
  # For dealing with ISOs
  programs.cdemu = {
    enable = true;
    gui = true;
  };

  # Note: most cutting edge emulators almost never get their versions backported to stable
  environment.systemPackages = with pkgs; [
    # Standalone emulators
    unstable.ares
    unstable.azahar
    unstable.cemu
    unstable.dolphin-emu
    unstable.dolphin-emu-primehack
    unstable.duckstation
    unstable.fsuae
    # unstable.fsuae-launcher # TODO: Restore
    lime3ds
    unstable.pcsx2
    unstable.ppsspp
    unstable.rpcs3
    unstable.ryubing  # Ryujinx fork with updated features
    unstable.shadps4
    unstable.xemu

    # PCSX2 build with ParaLLEl-GS
    pcsx2-pgs

    # Final available release, legally available and
    # fetched and built from the Software Heritage Archive
    yuzu

    # DOS/x86 emulation
    _86Box-with-roms
    dosbox-staging
    nuked-sc55 # Roland SC-55 emulation
    pcem
    # TODO: Package DBGL?
    
    # RetroArch
    retroarch

    # Tools
    #binaryobjectscanner # TODO: restore
    fusee-interfacee-tk   # For sending RCM payloads to Switch
    hactool               # For verifying Switch cart dumps 
    mame.tools            # Primarily for chdman
    mpf-check             # Helper tool for creating preservation submissions
    ps3-disc-dumper       # For dumping PS3 blu-rays
    redumper              # All purpose disc-dumping tool
    xdvdfs-cli            # For dealing with OG Xbox ISOs
  ];
}
