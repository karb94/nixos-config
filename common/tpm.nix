# TPM configuration
{pkgs, primaryUser, ... }:
{
  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;  # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
  # Set TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables /dev/tpmrm0
  security.tpm2.tctiEnvironment.enable = true;
  users.users."${primaryUser}".extraGroups = [ "tss" ];  # tss group has access to TPM devices
  # Fix fapi errors from https://github.com/NixOS/nixpkgs/pull/240803
  # Will be fixed here: https://github.com/NixOS/nixpkgs/pull/277023
  security.tpm2.pkcs11.package = pkgs.tpm2-pkcs11.override {
    fapiSupport = false;
  };
}
