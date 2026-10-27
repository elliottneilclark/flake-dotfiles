{ pkgs, ... }:

{
  time.timeZone = "America/Chicago";

  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    # Python is available system-wide for omp's tools.
    systemPackages = with pkgs; [ neovim killall age python3 ];
  };
}
