{ config, ... }:

let
  port = 9918;
in
{
  age.secrets.batteriesincl_wg = {
    file = ../../secrets/batteriesincl_wg.age;
  };

  networking.firewall = {
    allowedUDPPorts = [ port ];
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "100.64.250.6/32" ];
      listenPort = port;
      privateKeyFile = config.age.secrets.batteriesincl_wg.path;
      peers = [
        {
          publicKey = "fdjmLLICvyHpMVQMsimEQ0M+ueEN7fyHJv1muuPfskk=";
          allowedIPs = [ "100.64.0.0/16" "172.31.0.0/16" ];

          endpoint = "54.173.83.106:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
