{
  config,
  osConfig,
  lib,
  inputs,
  pkgs,
  firefox-addons,
  ...
}:
{
  options.zen-config = {
    enable = lib.mkEnableOption "enable zen config";
    userChrome = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "UserChrome css for zen browser.";
    };
    userContent = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "UserContent css for zen browser.";
    };
    darkreader-theme = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Theme for darkreader plugin, used to override defaults";
    };
    vimium-css = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Css for vimium plugin.";
    };
  };

  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  config =
    let
      cfg = config.zen-config;

      mkPluginUrl = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";

      mkExtensionEntry =
        {
          id,
          pinned ? false,
        }:
        let
          base = {
            install_url = mkPluginUrl id;
            installation_mode = "force_installed";
          };
        in
        if pinned then base // { default_area = "navbar"; } else base;

      mkExtensionSettings = builtins.mapAttrs (
        _: entry: if builtins.isAttrs entry then entry else mkExtensionEntry { id = entry; }
      );
    in
    lib.mkIf cfg.enable {
      programs.zen-browser = {
        # TODO: Add keyboard mappings once https://github.com/0xc000022070/zen-browser-flake/issues/138 is resolved
        enable = true;
        languagePacks = [
          "en-US"
          "de"
        ];

        nativeMessagingHosts = with pkgs; [
          keepassxc
        ];

        policies = {
          AutofillAddressEnabled = true;
          AutofillCreditCardEnabled = false;
          DisableAppUpdate = true;
          DisableFeedbackCommands = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          OfferToSaveLogins = false;
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          SanitizeOnShutdown = {
            FormData = true;
            Cache = true;
          };
          DNSOverHTTPS = {
            Enabled = true;
            ProviderURL = "https://cloudflare-dns.com/dns-query";
            Fallback = true;
            Locked = true;
          };
          ExtensionSettings = mkExtensionSettings {
            "uBlock0@raymondhill.net" = mkExtensionEntry {
              id = "ublock-origin";
              pinned = true;
            };
            "addon@darkreader.org" = "darkreader";
            "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = "vimium";
            "keepassxc-browser@keepassxc.org" = "keepassxc-browser";
            "languagetool-webextension@languagetool.org" = "languagetool";
          };
        };

        profiles.default = rec {
          id = 0;
          name = "default";
          isDefault = true;
          extensions = {
            packages = with firefox-addons; [
              ublock-origin
              darkreader
              vimium
              languagetool
              keepassxc-browser
            ];
            force = true;
            settings = {
              "addon@darkreader.org".settings = {
                schemeVersion = 2;

                enabled = true;
                enabledByDefault = true;
                syncSettings = false;
                syncSitesFixes = false;
                fetchNews = false;
                enabledFor = [ ];
                disabledFor = [ ];

                previewNewDesign = true;
                theme = {
                  "mode" = 1;
                  "brightness" = 100;
                  "contrast" = 100;
                  "grayscale" = 0;
                  "sepia" = 0;
                  "useFont" = false;
                  "fontFamily" = "Open Sans";
                  "textStroke" = 0;
                  "engine" = "dynamicTheme";
                  "stylesheet" = "";
                  "darkSchemeBackgroundColor" = "#0ff1f5";
                  "darkSchemeTextColor" = "#ff0000";
                  "lightSchemeBackgroundColor" = "#dcdad7";
                  "lightSchemeTextColor" = "#181a1b";
                  "scrollbarColor" = "auto";
                  "selectionColor" = "auto";
                  "styleSystemControls" = false;
                  "lightColorScheme" = "Default";
                  "darkColorScheme" = "Default";
                  "immediateModify" = false;
                }
                // cfg.darkreader-theme;

                "automation" = {
                  "enabled" = false;
                  "mode" = "";
                  "behavior" = "OnOff";
                };

                previewNewestDesign = false;
                enableForPDF = true;
                enableForProtectedPages = false;
                enableContextMenus = false;

                "detectDarkTheme" = true;
                "displayedNews" = [ ];
                "readNews" = [ ];

                "installation" = {
                  "date" = 1767057657601;
                  "reason" = "install";
                  "version" = "4.9.118";
                };
              };

              # TODO: Implement https://github.com/philc/vimium/issues/4600 Upstream
              # "{d7742d87-e61d-4b78-b8a1-b469842139fa}".settings = {
              #   settingsVersion = "2.3.1";
              #   userDefinedLinkHintCss = cfg.vimium-css;
              # };
            };
          };

          containersForce = true;
          containers = {
            General = {
              color = "blue";
              icon = "briefcase";
              id = 1;
            };
          };
          spacesForce = true;
          spaces = {
            "Default" = {
              id = "14d15d3e-b1d5-44dc-b8c2-daf59e3b7d12";
              icon = "🚀";
              position = 1000;
              container = containers.General.id;
            };
            "School" = {
              id = "b8de8bcb-21a0-4416-b763-6691cbc9b9a6";
              icon = "📖";
              position = 2000;
              container = containers.General.id;
            };
          };
          pinsForce = true;
          pins = {
            "mail" = {
              id = "c884e045-d180-404d-9883-0fb2eb3dc2b7";
              container = containers.General.id;
              url = "https://mail.proton.me";
              isEssential = true;
              position = 101;
            };
          };

          userChrome = cfg.userChrome;
          userContent = cfg.userContent;

          search = {
            force = true;
            default = "ddg";
            privateDefault = "ddg";
          };

          bookmarks = {
            force = true;
            settings = [
              {
                name = "Noogle";
                tags = [
                  "wiki"
                  "nix"
                ];
                url = "https://noogle.dev";
              }
              {
                name = "Color conversions";
                tags = [
                  "wiki"
                  "colors"
                  "lookup"
                ];
                url = "http://brucelindbloom.com/index.html";
              }
            ]
            ++ lib.optionals osConfig.syncthing-config.enable [
              {
                name = "Syncthing web-ui";
                tags = [
                  "syncthing"
                  "web-ui"
                ];
                url = "http://localhost:8384/";
              }
            ];
          };

          settings = {
            "browser.aboutConfig.showWarning" = false;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
            "extensions.autoDisableScopes" = 0;
            "ui.systemUsesDarkTheme" = 1;

            # Disable irritating first-run stuff
            "browser.disableResetPrompt" = true;
            "browser.download.panel.shown" = true;
            "browser.feeds.showFirstRunUI" = false;
            "browser.messaging-system.whatsNewPanel.enabled" = false;
            "browser.rights.3.shown" = true;
            "browser.shell.checkDefaultBrowser" = false;
            "browser.shell.defaultBrowserCheckCount" = 1;
            "browser.startup.homepage_override.mstone" = "ignore";
            "browser.uitour.enabled" = false;
            "startup.homepage_override_url" = "";
            "trailhead.firstrun.didSeeAboutWelcome" = true;
            "browser.bookmarks.restore_default_bookmarks" = false;
            "browser.bookmarks.addedImportButton" = true;
            "zen.welcome-screen.seen" = true;
          };
        };
      };
    };
}
