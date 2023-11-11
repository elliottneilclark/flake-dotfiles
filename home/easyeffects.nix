{ ... }:

{
  services.easyeffects =
    {
      enable = true;
      preset = "optimized";
    };

  # based on https://gist.github.com/MateusRodCosta/a10225eb132cdcb97d7c458526f93085
  xdg.configFile."easyeffects/input/optimised.json".text = builtins.toJSON {
    input = {
      blocklist = [ ];
      plugins_order = [ "rnnoise#0" "compressor#0" "deesser#0" "speex#0" "limiter#0" ];
      "rnnoise#0" = {
        bypass = false;
        input-gain = 0.0;
        model-path = "";
        output-gain = 0.0;
      };
      "compressor#0" = {
        attack = 5.0;
        boost-amount = 6.0;
        boost-threshold = -72.0;
        bypass = false;
        dry = -100.0;
        hpf-frequency = 10.0;
        hpf-mode = "off";
        input-gain = 0.0;
        knee = -6.0;
        lpf-frequency = 20000.0;
        lpf-mode = "off";
        makeup = 0.0;
        mode = "Downward";
        output-gain = 0.0;
        ratio = 4.0;
        release = 75.0;
        release-threshold = -40.0;
        sidechain = {
          lookahead = 0.0;
          mode = "RMS";
          preamp = 0.0;
          reactivity = 10.0;
          source = "Middle";
          type = "Feed-forward";
        };
        threshold = -20.0;
        wet = 0.0;
      };
      "deesser#0" = {
        bypass = false;
        detection = "RMS";
        f1-freq = 3000.0;
        f1-level = -6.0;
        f2-freq = 5000.0;
        f2-level = -6.0;
        f2-q = 1.5;
        input-gain = 0.0;
        laxity = 15;
        makeup = 0.0;
        mode = "Wide";
        output-gain = 0.0;
        ratio = 5.0;
        sc-listen = false;
        threshold = -20.0;
      };
      "speex#0" = {
        bypass = false;
        input-gain = 0.0;
        output-gain = 0.0;
        noise-suppression = -70;
        enable-agc = true;
        enable-denoise = true;
        enable-dereverb = true;
        vad = {
          enable = true;
          probability-continue = 90;
          probability-start = 95;
        };
      };
      "limiter#0" = {
        alr = false;
        alr-attack = 5.0;
        alr-knee = 0.0;
        alr-release = 50.0;
        attack = 1.0;
        bypass = false;
        dithering = "16bit";
        external-sidechain = false;
        gain-boost = true;
        input-gain = 0.0;
        lookahead = 5.0;
        mode = "Herm Wide";
        output-gain = 0.0;
        oversampling = "Half x2(2L)";
        release = 5.0;
        sidechain-preamp = 0.0;
        stereo-link = 100.0;
        threshold = -1.0;
      };
    };
  };
}
