{ pkgs, ... }:
let 
  # Some wrappers to include Node on the path of Jetbrains IDEs because Amazon Q 
  # needs it for some reason
  idea = pkgs.unstable.jetbrains.idea.overrideAttrs (old: {
    postInstall = ''
      wrapProgram $out/bin/idea \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.nodejs ]}
    '';
  });
  rust-rover = pkgs.unstable.jetbrains.rust-rover.overrideAttrs (old: {
    postInstall = ''
      wrapProgram $out/bin/rust-rover \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.nodejs ]}
    '';
  });
in {
  environment.systemPackages = with pkgs; [
    jetbrains.clion
    idea
    jetbrains.goland
    jetbrains.rider
    rust-rover
  ];
}