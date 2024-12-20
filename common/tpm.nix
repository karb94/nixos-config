# TPM configuration
{pkgs, primaryUser, ... }:
{
  security.tpm2 = {
    enable = true;
    # Set TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables /dev/tpmrm0
    tctiEnvironment.enable = true;

    # Fix fapi errors from https://github.com/NixOS/nixpkgs/pull/240803
    # Will be fixed here: https://github.com/NixOS/nixpkgs/pull/277023
    pkcs11 = {
      enable = true;  # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
      package = pkgs.tpm2-pkcs11.override { fapiSupport = false; };
    };
  };
  users.users."${primaryUser}".extraGroups = [ "tss" ];  # tss group has access to TPM devices

  # Use TPM as a WebAuthn token
  environment.systemPackages = [ pkgs.tpm-fido pkgs.pinentry-qt ];

  # udev rules for tpm-fido
  services.udev.extraRules = ''
      KERNEL=="uhid", SUBSYSTEM=="misc", GROUP="tss", MODE="0660"
  '';
  boot.kernelModules = [ "uhid" ];

  # tpm-fido service
  systemd.user.services.tpm-fido = {
    wantedBy = [ "graphical.target" ];
    path = [ pkgs.pinentry-qt ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.tpm-fido}/bin/tpm-fido";
    };
  };
}
