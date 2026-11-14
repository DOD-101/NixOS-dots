{
  ...
}:
let
  domain = "dod-101.com";
  internal = "home.${domain}";
  serverIp = "192.168.178.37";
  routerIp = "192.168.178.1";
  # email = "you@example.com";
  dnsPort = 53;

  v = import ./vars.nix;
in
{
  services.blocky = {
    enable = true;
    settings = {
      ports.dns = dnsPort;

      # Everything external goes to Cloudflare over DoH
      upstreams.groups.default = [ "https://cloudflare-dns.com/dns-query" ];

      # Needed to resolve the DoH hostname itself
      bootstrapDns = [
        {
          upstream = "https://cloudflare-dns.com/dns-query";
          ips = [
            "1.1.1.1"
          ];
        }
      ];

      # all internal domains go to the server
      customDNS.mapping.${internal} = serverIp;

      # Fritz!Box names go to the router
      conditional.mapping."fritz.box" = routerIp;

      # Show device names instead of IPs in logs (reverse lookup via the router)
      clientLookup.upstream = routerIp;

      blocking = { };

      caching.prefetching = true;
      log.level = "info";
    };
  };

  # Make sure nothing else holds port 53
  services.resolved.enable = false;

  networking.nameservers = [ "127.0.0.1" ];

  networking.firewall = {
    allowedTCPPorts = [
      dnsPort
      80
      443
    ];
    allowedUDPPorts = [ dnsPort ];
  };

  # NOTE: Could set up HTTPS here in the future

  # security.acme = {
  #   acceptTerms = false; # disable it for now
  #   defaults.email = email;

  #   certs.${internal} = {
  #     domain = internal;
  #     extraDomainNames = [ "*.${internal}" ];
  #     dnsProvider = "cloudflare";
  #     credentialsFile = "/var/lib/secrets/cloudflare-acme.env";
  #     # Blocky overrides home.example.com locally, so check propagation
  #     # against a public resolver instead of the local one
  #     dnsResolver = "1.1.1.1:53";
  #     group = config.services.nginx.group;
  #   };
  # };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;

    virtualHosts = {
      # Reject unknown names instead of serving a random site
      "_" = {
        default = true;
        # useACMEHost = internal;
        forceSSL = false;
        locations."/".return = "404";
      };

      "ha.${internal}" = {
        # useACMEHost = internal;
        forceSSL = false;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString v.haFrontendPort}";
          proxyWebsockets = true;
        };
      };

      "z2mqtt.${internal}" = {
        # useACMEHost = internal;
        forceSSL = false;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString v.z2mFrontendPort}";
          proxyWebsockets = true;
        };
      };

      "coordinator.${internal}" = {
        # useACMEHost = internal;
        forceSSL = false;
        locations."/" = {
          proxyPass = "http://192.168.178.40";
          proxyWebsockets = true;
        };
      };
    };
  };
}
