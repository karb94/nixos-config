self: super: {
  yt-dlp = super.yt-dlp.overrideAttrs (oldAttrs: rec {
    version = "2025.6.09";
    src = super.fetchFromGitHub {
      owner = "yt-dlp";
      repo = "yt-dlp";
      rev = version;
      hash = "sha256-l18DeZRQjyNc1OoSCsOk5BLYL6QjG246i+sQn0AWZEc=";
    };
    # src = super.fetchPypi {
    #   inherit version;
    #   pname = "yt_dlp";
    #   hash = "";
    # };
  });
}
