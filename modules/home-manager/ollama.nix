{ pkgs-unstable, ... }:
{
  home.packages = [ pkgs-unstable.ollama ];

  home.sessionVariables = {
    OLLAMA_MODELS = "/data/ollama/models";
  };

  programs.zsh.shellAliases = {
    ollama-serve = "nvidia-offload ollama serve";
    llm = "ollama run";
  };
}
