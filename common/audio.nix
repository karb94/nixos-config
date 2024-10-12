# Audio
{
  # Bluetooth
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.bluetooth.enable = true;
  environment.persistence.system.directories = [ "/var/lib/bluetooth" ];
}
