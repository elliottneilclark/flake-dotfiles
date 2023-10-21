{ pkgs, ... }:
{

  environment = {
    shells = [ pkgs.zsh ];
    loginShell = pkgs.zsh;
    pathsToLink = [ "/Applications" ];
    systemPath = [ "/opt/homebrew/bin" ];
    systemPackages = with pkgs; [
      coreutils
    ];
  };
}
