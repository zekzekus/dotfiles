{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    haruna
    loupe
    papers
  ];

  # User-local Niri defaults take precedence over mimeapps.list without
  # replacing its browser/link handlers or changing other accounts' Plasma.
  xdg.configFile."niri-mimeapps.list".text = lib.generators.toINI {} {
    "Default Applications" =
      lib.genAttrs [
        "image/apng"
        "image/avif"
        "image/bmp"
        "image/gif"
        "image/heic"
        "image/jp2"
        "image/jpeg"
        "image/jxl"
        "image/png"
        "image/qoi"
        "image/svg+xml"
        "image/svg+xml-compressed"
        "image/tiff"
        "image/vnd.microsoft.icon"
        "image/webp"
        "image/x-dds"
        "image/x-exr"
        "image/x-portable-anymap"
        "image/x-portable-bitmap"
        "image/x-portable-graymap"
        "image/x-portable-pixmap"
        "image/x-qoi"
        "image/x-tga"
        "image/x-win-bitmap"
        "image/x-xbitmap"
        "image/x-xpixmap"
      ] (_: "org.gnome.Loupe.desktop")
      // lib.genAttrs [
        "video/mp2t"
        "video/mp4"
        "video/mpeg"
        "video/ogg"
        "video/quicktime"
        "video/vnd.avi"
        "video/webm"
        "video/x-matroska"
        "video/x-ms-wmv"
      ] (_: "org.kde.haruna.desktop")
      // lib.genAttrs [
        "application/pdf"
        "application/x-bzpdf"
        "application/x-ext-pdf"
        "application/x-gzpdf"
        "application/x-xzpdf"
      ] (_: "org.gnome.Papers.desktop");
  };
}
