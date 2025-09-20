final: prev: {
  yt-dlp = prev.yt-dlp.overrideAttrs (oldAttrs: rec {
    src = prev.fetchFromGitHub {
      owner = "yt-dlp";
      repo = "yt-dlp";
      rev = "2025.09.05";
      hash = "sha256-9y6OUVm6hNTTi5FFmd9DHcmAMrvSmDD+4kDe00aMTDI=";
    };
  });
}
