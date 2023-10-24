{ stdenv, lib, fetchFromGitHub, kernel, kmod, nukeReferences }:

stdenv.mkDerivation rec {
  name = "avmvc12-${version}-${kernel.version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "GloriousEggroll";
    repo = "AVMATRIX-VC12-4K-CAPTURE";
    rev = "3f5f02d78b0572479dc23319c6b666f5ca23cc3a";
    hash = "sha256-XdY/+xM3WANqwKKryCUQ5fWAYXRk4ek4v0TU0rev3xU=";
  };

  sourceRoot = "source/src";

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [ nukeReferences ] ++ [ kernel.moduleBuildDependencies ];

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    # "INSTALL_MOD_PATH=$(out)"
  ];

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/drivers/misc
    for x in $(find . -name '*.ko'); do
      nuke-refs $x
      cp $x $out/lib/modules/${kernel.modDirVersion}/drivers/misc/
    done
  '';

  meta = with lib; {
    description = "Kernel module for AVMATRIX VC12-4K PCIe video capture card with small modifications by GloriousEggroll (Thomas Crider).";
    homepage = "https://www.avmatrix.com/products/vc12-4k-4k-hdmi-pcie-capture-card/";
    license = licenses.gpl2;
    # maintainers = [ maintainers.makefu ];
    platforms = platforms.linux;
  };
}