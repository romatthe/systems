{ pkgs, ... }:
let 

  # Some wrappers to include Node on the path of Jetbrains IDEs because Amazon Q needs it
  intellij = pkgs.unstable.jetbrains.idea.overrideAttrs (old: {
    postInstall = ''
      wrapProgram $out/bin/idea \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.nodejs ]}
        --add-flags "-Didea.config.path=$HOME/.config/JetBrains/IntelliJ"
    '';
  });

  rust-rover = pkgs.unstable.jetbrains.rust-rover.overrideAttrs (old: {
    postInstall = ''
      wrapProgram $out/bin/rust-rover \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.nodejs ]} \
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
    jetbrains.clion
    intellij
    jetbrains.goland
    jetbrains.rider
    rust-rover
  ];

  # 
  home-manager.users.romatthe.home.file.".config/JetBrains/IntelliJ/options/jdk.table.xml".source =
    jdkTableXml;
}