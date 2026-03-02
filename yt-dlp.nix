final: prev: {
  yt-dlp = prev.yt-dlp.overrideAttrs (oldAttrs: rec {
    src = prev.fetchFromGitHub {
      owner = "yt-dlp";
      repo = "yt-dlp";
      rev = "2026.02.21";
      hash = "sha256-r9I/zLyqGPeIzsHsLxJcfnLC3jpuyKMyX1UaMoM08jk=";
    };
  });
}
