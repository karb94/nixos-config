# TPM configuration
{pkgs, primaryUser, ... }:
{
  # Install tpm2-tools for more tools to interact with the TPM (e.g., clear store)
  # How to create an tpm2 ssh key
  # doas tpm2_ptool init --path=/etc/tpm2_pkcs11
  # doas tpm2_ptool addtoken --pid=1 --label=ssh --userpin=USERPIN --sopin=ADMINPIN
  # doas tpm2_ptool addkey --algorithm=ecc256 --label=ssh --userpin=USERPIN
  # Remember to persist tpm2_pkcs11 store in $HOME/.tpm2_pkcs11
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
  # tss group has access to TPM devices
  users.users."${primaryUser}".extraGroups = [ "tss" ];
  # Persist tpm2_pkcs11 store in /etc/tpm2_pkcs11
  # environment.persistence.system.directories = [ "/etc/tpm2_pkcs11" ];
  # environment.variables = { PKCS11_SQL_LOCK = "/run/pkcs11_sql_locks"; };

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
