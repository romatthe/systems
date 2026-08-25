{ pkgs, ... }:
{
  # Ollama service with ROCm
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm; # Acceleration method happens through package selection
    # package = pkgs.ollama-vulkan;
    
    environmentVariables = {
      # HSA_OVERRIDE_GFX_VERSION = "11.0.0";  # For RX 7900 XTX
      # OLLAMA_NUM_GPU = "999";
      # OLLAMA_NUM_CTX = "196608";
    };
  };

   # Enable Open WebUI service
  services.open-webui = {
    enable = true;
    host = "0.0.0.0";
    port = 9000;
  };

  environment.systemPackages = with pkgs; [
    claude.claude-code # Seperate nixpkgs-unstable input to not affect all other packages
    unstable.goose-cli
    unstable.opencode
  ];
}