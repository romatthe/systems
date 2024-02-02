final: prev: {
  aaru                  = prev.callPackage ./aaru { };
  luxtorpeda            = prev.callPackage ./luxtorpeda { };
  nuvie                 = prev.callPackage ./nuvie { };
  ps3-disc-dumper       = prev.callPackage ./ps3-disc-dumper { };
  redumper              = prev.callPackage ./redumper { };
  samrewritten          = prev.callPackage ./samrewritten { };
  steam-metadata-editor = prev.callPackage ./steam-metadata-editor { };
  wlogoutbar            = prev.callPackage ./wlogoutbar { };
  xdvdfs-cli            = prev.callPackage ./xdvdfs-cli { };
}