{ pkgs, ... }:
let 

  # Some wrappers to include Node on the path of Jetbrains IDEs because Amazon Q needs it
  # intellij = pkgs.unstable.jetbrains.idea.overrideAttrs (old: {
  #   postInstall = ''
  #     wrapProgram $out/bin/idea \
  #       --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.nodejs ]} \
  #       --add-flags "-Didea.config.path=$HOME/.config/JetBrains/IntelliJ"
  #   '';
  # });

  clion = pkgs.unstable.jetbrains.clion.overrideAttrs (old: {
    postInstall = ''
      wrapProgram $out/bin/clion \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.cmake pkgs.gcc pkgs.nodejs ]}
    '';
  });

  idea = pkgs.unstable.jetbrains.idea.overrideAttrs (old: {
    postInstall = ''
      wrapProgram $out/bin/idea \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.jdk21 pkgs.jdk25 pkgs.nodejs ]}
    '';
  });

  goland = pkgs.unstable.jetbrains.goland.overrideAttrs (old: {
    postInstall = ''
      wrapProgram $out/bin/goland \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.nodejs ]}
    '';
  });

  # rider = pkgs.unstable.jetbrains.rider.overrideAttrs (old: {
  #   postInstall = ''
  #     wrapProgram $out/bin/rider \
  #       --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.nodejs pkgs.openssl]}
  #   '';
  # });

  rider = pkgs.unstable.jetbrains.rider;

  rust-rover = pkgs.unstable.jetbrains.rust-rover.overrideAttrs (old: {
    postInstall = ''
      wrapProgram $out/bin/rust-rover \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.nodejs ]}
    '';
  });

  jdks = [
    { version = "21"; pkg = pkgs.jdk21; }
    { version = "25"; pkg = pkgs.jdk25; }
  ];

  jdkEntries =
    pkgs.lib.concatMapStringsSep "\n"
      (j: ''
        <jdk version="2">
          <name value="Nix Java ${j.version}"/>
          <type value="JavaSDK"/>
          <homePath value="${j.pkg}"/>
          <roots>
            <classPath/>
            <sourcePath/>
          </roots>
        </jdk>
      '')
      jdks;

  jdkTableXml = pkgs.writeText "jdk.table.xml" ''
    <application>
      <component name="ProjectJdkTable">
        ${jdkEntries}
      </component>
    </application>
  '';

in {
  environment.systemPackages = with pkgs; [
    clion
    idea
    # intellij
    goland
    rider
    rust-rover
  ];
 
  # Symlink the JDK table XMLfile
  # home-manager.users.romatthe.home.file.".config/JetBrains/IntelliJ/options/jdk.table.xml".source =
  #   jdkTableXml;

  # Copy the JDK table XML file after home-manager completes its activation. This is so that IntelliJ can still write its
  # necessary junk to it. The file will be overwritten every time a new configuration is activated, which should be fine.
  # home-manager.users.romatthe.home.activation.installIdeaJdks = pkgs.lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   mkdir -p "$HOME/.config/JetBrains/IntelliJ/options"
  #   cp -f ${jdkTableXml} \
  #     "$HOME/.config/JetBrains/IntelliJ/options/jdk.table.xml"
  # '';
}