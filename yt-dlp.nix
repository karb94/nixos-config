final: prev: {
  yt-dlp = prev.yt-dlp.overrideAttrs (oldAttrs: rec {
    src = prev.fetchFromGitHub {
      owner = "yt-dlp";
      repo = "yt-dlp";
      rev = "2026.01.31";
      hash = "sha256-3sXXyWuQI6KTOQIkkOfJhCTBBh3Zkv59ENhkrz9Sgxc=";
    };
  });
}
