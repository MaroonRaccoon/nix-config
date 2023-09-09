{ pkgs, ... }:
{
  networking.hostName = "mapa-desktop";
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u14n.psf.gz";
}
