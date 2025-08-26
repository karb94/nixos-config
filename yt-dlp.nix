final: prev: {
  yt-dlp = prev.yt-dlp.overrideAttrs (oldAttrs: rec {
    src = prev.fetchFromGitHub {
      owner = "yt-dlp";
      repo = "yt-dlp";
      rev = "2025.08.22";
      hash = "sha256-58Qj+Bt4GEGgWpqAuMVemixm5AUcqS+e2Sajoeun8KY=";
    };
  });
}
