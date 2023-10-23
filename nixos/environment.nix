{ pkgs, ... }:

{
  time.timeZone = "America/Chicago";

  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [ neovim killall ];
  };
}
