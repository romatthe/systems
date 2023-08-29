{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    unstable.frida-tools
    unstable.ghidra

    ## Rizin
    unstable.cutter  
    unstable.rizin   # Fork of radare2

    ## Radare2
    # iaito
    # radare2
  ];
}