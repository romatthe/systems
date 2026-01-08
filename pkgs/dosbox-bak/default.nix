{ lib
, stdenv
, copyDesktopItems
, makeDesktopItem
, dosbox-staging
, fetchzip
, imagemagick
, innoextract
, nuked-sc55
, requireFile
, writeShellScript
}:
let
  installerName = "setup_betrayal_at_krondor_2.1.0.19.exe";
  installer = requireFile {
    name = installerName;
    message = ''
      This nix expression requires that the GOG Betrayal at Krondor installer 
      "setup_betrayal_at_krondor_2.1.0.19.exe" is already part of the nix store.
      To get this file, download it from GOG's website and add it to the nix store 
      with "nix-store --add-fixed sha256 <FILE>".
    '';
    sha256 = "8207fa670ea4089ad7be9aaf14cc9371887b6f3cb8d42182b009e9de945cf5a4";
  };
  launcher = writeShellScript "launch-dosbox-bak" ''
    # Remove a potentially old dosbox-staging conf file so as not to inherit old defaults
    rm -f ~/.config/dosbox/dosbox-staging.conf

    # Make sure the save directory is created
    mkdir -p ~/.local/share/dosbox-saves/bak

    # Run Nuked-SC55 for MIDI music
    ${nuked-sc55}/bin/nuked-sc55 -p0:128 -gs & pid_nuked=$!
    sleep 2

    ${dosbox-staging}/bin/dosbox-staging --working-dir @out@/share/bak & pid_dosbox=$!

    # Cleaunup
    wait $pid_dosbox
    kill $pid_nuked
  '';
in stdenv.mkDerivation rec {
  pname = "dosbox-bak";
  version = "1.0.0";

  src = installer;

  # MIDI music and sound patch
  patch = fetchzip {
    url = "https://archive.org/download/bak-midifix/bak-midifix.zip";
    hash = "sha256-Z8jXsN8bUSr1dmM6L/vKabeFnAH6r1sNbXIBED67OaA=";
    stripRoot = false;
  };

  dontUnpack = true;

  nativeBuildInputs = [
    copyDesktopItems
    imagemagick
    innoextract
  ];

  desktopItems = [ 
    (makeDesktopItem {
      name = "dosbox-bak";
      desktopName = "Betrayal at Krondor";
      exec = "${placeholder "out"}/bin/${launcher.name}";
      icon = "dosbox-bak";
      comment = "Betrayal at Krondor running in DOSBox Staging";
      categories = [ "Game" "RolePlaying" ];
    })
  ];

  buildPhase = ''
    runHook preBuild

    innoextract $src

    mv app/* ./

    rm -Rf app/ commonappdata/ tmp/ __support/ DOSBOX/
    rm *.conf *.dll *.hashdb *.info *.pdf readme.txt webcache.zip

    mv bak.gog  bak.bin
    mv bak.inst bak.cue
    mv *.ico    bak.ico

    substituteInPlace bak.cue \
      --replace "bak.gog" "bak.bin"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/bak/drives/c/
    mkdir -p $out/share/bak/cd/music

    install -Dm755 ${launcher} $out/bin/${launcher.name}
    substituteInPlace $out/bin/${launcher.name} --subst-var out

    install -Dm644 bak.bin      $out/share/bak/cd/
    install -Dm644 bak.cue      $out/share/bak/cd/
    install -Dm644 music/*      $out/share/bak/cd/music/

    install -Dm644 *.DRV        $out/share/bak/drives/c/
    install -Dm644 *.CFG        $out/share/bak/drives/c/
    # install -Dm644 FRP.SX       $out/share/bak/drives/c/
    install -Dm644 INSTALL.EXE  $out/share/bak/drives/c/
    install -Dm644 INSTALL.HLP  $out/share/bak/drives/c/
    install -Dm644 INSTALL.SCR  $out/share/bak/drives/c/
    install -Dm644 INSTALL.SCR  $out/share/bak/drives/c/
    install -Dm644 KRONDOR.001  $out/share/bak/drives/c/
    # install -Dm644 KRONDOR.EXE  $out/share/bak/drives/c/
    install -Dm644 KRONDOR.RMF  $out/share/bak/drives/c/
    install -Dm644 STARTUP.GAM  $out/share/bak/drives/c/
    install -Dm644 VMCODE.OVL   $out/share/bak/drives/c/

    # Patch to fix combined MIDI + sound playback
    install -Dm644 ${patch}/FRP.SX       $out/share/bak/drives/c/
    install -Dm644 ${patch}/KRONDOR.EXE  $out/share/bak/drives/c/
    install -Dm644 ${patch}/RESOURCE.CFG $out/share/bak/drives/c/
    install -Dm644 ${patch}/SX.OVL       $out/share/bak/drives/c/

    # Extract icon for different sizes
    for size in 16 24 32 48 64 128 256 ; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      magick "bak.ico[5]" -resize "$size"x"$size" \
        $out/share/icons/hicolor/"$size"x"$size"/apps/dosbox-bak.png
    done;

    # DOSBox Staging configuration
    cat > $out/share/bak/dosbox.conf <<EOF
    [sdl]
    fullscreen = true
    pause_when_inactive = false
    vsync = true

    [render]
    glshader = crt-auto

    [cpu]
    core                 = auto
    cputype              = auto
    cpu_cycles           = 20000
    cpu_cycles_protected = 20000
    cpu_throttle         = false

    [dosbox]
    automount = false

    [midi]
    mididevice      = alsa
    midiconfig      = 128:0
    mpu401          = intelligent
    raw_midi_output = false

    [autoexec]
    imgmount d cd/bak.cue -t iso -fs iso
    mount c "$out/share/bak/drives/c"
    mount c "~/.local/share/dosbox-saves/bak" -t overlay
    c:
    cls
    EOF

    runHook postInstall
  '';
}