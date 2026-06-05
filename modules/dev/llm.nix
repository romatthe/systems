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

  environment.systemPackages = with pkgs; [
    goose-cli
    opencode
  ];
}