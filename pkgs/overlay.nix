final: prev: {
  # ambermoon-net         = prev.callPackage ./ambermoon-net { }; # TODO: move to .NET 8
  binaryobjectscanner   = prev.callPackage ./binaryobjectscanner { };
  dosbox-mmwox          = prev.callPackage ./dosbox-mmwox { };
  luxtorpeda            = prev.callPackage ./luxtorpeda { };
  nuked-sc55            = prev.callPackage ./nuked-sc55 { };
  redumper              = prev.callPackage ./redumper { };
  steam-metadata-editor = prev.callPackage ./steam-metadata-editor { };
  waybackpack           = prev.callPackage ./waybackpack { };
  xdvdfs-cli            = prev.callPackage ./xdvdfs-cli { };
  yuzu                  = prev.callPackage ./yuzu { };
  
  # Packages broken since 24.05, relies on 23.11 for now
  mpf-check             = prev.callPackage ./mpf-check { 
    lib                = final.old.lib;
    buildDotnetModule  = final.old.buildDotnetModule;
    dotnetCorePackages = final.old.dotnetCorePackages;
    fetchFromGitHub    = final.old.fetchFromGitHub;
    openssl            = final.old.openssl;
    zlib               = final.old.zlib;
  };
  ps3-disc-dumper       = prev.callPackage ./ps3-disc-dumper {
    lib               = final.old.lib;
    buildDotnetModule = final.old.buildDotnetModule;
    dotnet-sdk_8      = final.old.dotnet-sdk_8;
    fetchFromGitHub   = final.old.fetchFromGitHub;
    openssl           = final.old.openssl;
    zlib              = final.old.zlib;
  };
  samrewritten          = prev.callPackage ./samrewritten { 
    stdenv          = final.old.stdenv;
    lib             = final.old.lib;
    fetchFromGitHub = final.old.fetchFromGitHub;
    curl            = final.old.curl;
    gnumake         = final.old.gnumake;
    gnutls          = final.old.gnutls;
    gtk3            = final.old.gtk3;
    gtkmm3          = final.old.gtkmm3;
    pkg-config      = final.old.pkg-config;
    yajl            = final.old.yajl;
  };
}