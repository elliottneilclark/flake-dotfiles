inputs: { config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    omp
    jq
    ranger
    unzip
    zip
    unrar
    wget
    curl
    age
    whois
    dnsutils
    doggo
    fd
    pstree
  ];

  home.file.".agents/skills/asd-ste100".source = inputs.asd-ste100.outPath;
  # Claude uses its own skills directory; link it to the shared agent skills.
  home.file.".claude/skills/asd-ste100".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.agents/skills/asd-ste100";

  programs.claude-code = {
    enable = true;
    mutableSettings = true;
    # Disable commit, PR, and session-link attribution.
    settings.attribution = {
      commit = "";
      pr = "";
      sessionUrl = false;
    };
  };

  # omp needs a writable config, so seed it once instead of linking it from the store.
  # A symlink left by an older generation is replaced; a real file is kept.
  home.activation.ompConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    cfg="$HOME/.omp/agent/config.yml"
    if [ ! -f "$cfg" ] || [ -L "$cfg" ]; then
      run rm -f "$cfg"
      run install -Dm644 ${pkgs.writeText "omp-config.yml" ''
        modelRoles:
          default: openai-codex/gpt-6.1-terra
          slow: openai-codex/gpt-6-astra:high
          smol: openai-codex/gpt-6.1-terra:high
        symbolPreset: nerd
        composer:
          shape: band
        theme:
          dark: titanium
        defaultThinkingLevel: auto
      ''} "$cfg"
    fi
  '';
}
