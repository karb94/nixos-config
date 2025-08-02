final: prev: {
  yt-dlp = prev.yt-dlp.overrideAttrs (oldAttrs: rec {
    src = prev.fetchFromGitHub {
      owner = "yt-dlp";
      repo = "yt-dlp";
      rev = "2025.07.21";
      hash = "sha256-VNUkCdrzbOwD+iD9BZUQFJlWXRc0tWJAvLnVKNZNPhQ=";
    };
  });
}
