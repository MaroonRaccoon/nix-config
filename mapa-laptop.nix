{ pkgs, ... }:
{
  networking.hostName = "mapa-laptop";
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
}
