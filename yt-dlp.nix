self: super: {
  yt-dlp = super.yt-dlp.overrideAttrs (oldAttrs: rec {
    version = "2025.5.22";
    src = super.fetchPypi {
      inherit version;
      pname = "yt_dlp";
      hash = "sha256-6nOFTF2rwSTymjWo+um8XUIu8yMb6+6ivfqCrBkanCk=";
    };
  });
}
