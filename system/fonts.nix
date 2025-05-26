{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
in
{
  options = {
    system = {
      fonts = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };
      };
    };
  };
  config =
    let
      inherit (builtins) attrValues;
      inherit (config) system;
      inherit (system) fonts;
    in
    mkIf fonts.enable {
      fonts = {
        enableDefaultPackages = false;
        packages = attrValues {
          inherit (pkgs)
            # noto
            noto-fonts
            noto-fonts-extra
            noto-fonts-cjk-sans
            noto-fonts-cjk-serif
            noto-fonts-color-emoji
            # microsoft
            corefonts
            # google
            roboto
            roboto-mono
            open-sans
            # custom
            berkeley-mono
            apple-fonts
            ;

          nerdfonts = pkgs.nerdfonts.override {
            fonts = [ "NerdFontsSymbolsOnly" ];
          };
        };
        fontconfig = {
          defaultFonts = {
            serif = [
              "New York Medium"
              "Noto Color Emoji"
            ];
            sansSerif = [
              "SF Pro Text"
              "Noto Color Emoji"
            ];
            monospace = [
              "Berkeley Mono"
              "Noto Color Emoji"
            ];
            emoji = [
              "Noto Color Emoji"
            ];
          };
        };
      };
    };
}
