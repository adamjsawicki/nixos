{ pkgs-unstable, ... }:
{
  home.packages = [ pkgs-unstable.ollama-cuda ];

  home.sessionVariables = {
    OLLAMA_MODELS = "/data/ollama/models";
  };
}
