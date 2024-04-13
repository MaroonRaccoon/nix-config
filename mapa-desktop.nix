{ pkgs, ... }:
let
  udevRules = {
    # make STM32 STLink device writable so you can flash to it
    stm32f401re = '' SUBSYSTEM=="usb", ATTR{product}=="STM32 STLink", ACTION=="add", MODE="0666" '';
    stm32g431kb = '' SUBSYSTEM=="usb", ATTR{product}=="STLINK-V3", ACTION=="add", MODE="0666" '';
    # make saleae logic analyzer writable for pulseview
    #saleae = '' SUBSYSTEM=="usb", ATTR{product}=="Saleae Logic", ACTION="add", MODE="0666" '';
    saleae = '' SUBSYSTEM=="usb", ATTR{idVendor}=="0925", ATTR{idProduct}=="3881", ACTION=="add", MODE="0666" '';
  };
in
{
  networking.hostName = "mapa-desktop";
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u14n.psf.gz";
  services.udev = {
    enable = true;
    extraRules = ''
      ${udevRules.stm32f401re}
      ${udevRules.stm32g431kb}
      ${udevRules.saleae}
    '';
  };
}
