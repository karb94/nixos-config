# Bluetooth
{
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        FastConnectable = true;
      };
    };
  };
  # Persist directory of trusted devices
  environment.persistence.system.directories = [ "/var/lib/bluetooth" ];
}
