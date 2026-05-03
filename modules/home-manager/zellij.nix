{ pkgs, ... }:
{
  home.file.".config/zellij/plugins/zellij-attention.wasm".source = pkgs.fetchurl {
    url = "https://github.com/KiryuuLight/zellij-attention/releases/download/v0.3.1/zellij-attention.wasm";
    sha256 = "0bvjzmh66qbd7ali40awpddr16k9xzrn4cvkxi418wqsnrx362a2";
  };
}
