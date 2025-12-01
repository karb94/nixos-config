final: prev: {
  yt-dlp = prev.yt-dlp.overrideAttrs (oldAttrs: rec {
    src = prev.fetchFromGitHub {
      owner = "yt-dlp";
      repo = "yt-dlp";
      rev = "2025.11.12";
      hash = "sha256-Em8FLcCizSfvucg+KPuJyhFZ5MJ8STTjSpqaTD5xeKI=";
    };
  });
}
