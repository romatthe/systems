{ pkgs, ... }:
let 
  # Some wrappers to include Node on the path of Jetbrains IDEs because Amazon Q 
  # needs it for some reason
  idea-ultimate = pkgs.unstable.jetbrains.idea-ultimate.overrideAttrs (old: {
    postInstall = ''
      wrapProgram $out/bin/idea-ultimate \
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
    unstable.jetbrains.clion
    idea-ultimate
    unstable.jetbrains.goland
    unstable.jetbrains.rider
    rust-rover
  ];
}