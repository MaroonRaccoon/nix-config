{ pkgs, ... }:
{
  networking.hostName = "mapa-desktop";
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u14n.psf.gz";
  services.udev = {
    enable = true;
    # this rule makes the STM32 STLink device writable when it is connected, so you can flash to it
    extraRules = ''
      SUBSYSTEM=="usb", ATTR{product}=="STM32 STLink", ACTION=="add", MODE="0666"
    '';
  };
}
