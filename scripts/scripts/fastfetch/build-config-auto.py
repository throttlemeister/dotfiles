#!/usr/bin/env python3
"""Build fastfetch config with a gradient sampled from the current wallpaper.

Usage:
  build-config-auto.py OUT [--wallpaper PATH_OR_URL] [--stops N]

If --wallpaper is omitted, tries to detect the current KDE Plasma wallpaper.
Falls back to the built-in "Hanabi" gradient when detection/extraction fails.
"""
import argparse, colorsys, json, os, re, subprocess, sys
from pathlib import Path

# Fallback gradient (KDE "Next" / Hanabi, dark)
DEFAULT_STOPS = ["#7866AA", "#7478C2", "#7089D2", "#8F7AC0", "#9E8FBC", "#BE8BAE", "#CB8F80", "#D99A55"]
DEFAULT_THEME = "Hanabi (fallback)"

FROST, SLATE, DIM = "#E2E0EE", "#948CB8", "#3A3152"
AMBER, TEAL, CORAL = "#D99A55", "#82B7B8", "#CC736C"


def _to_linear(c):
    c /= 255
    return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4


def _to_srgb(c):
    v = 12.92 * c if c <= 0.0031308 else 1.055 * c ** (1 / 2.4) - 0.055
    return max(0, min(255, round(v * 255)))


def lerp(a, b, t):
    a = [int(a[i:i + 2], 16) for i in (1, 3, 5)]
    b = [int(b[i:i + 2], 16) for i in (1, 3, 5)]
    return "#" + "".join(
        f"{_to_srgb(_to_linear(x) * (1 - t) + _to_linear(y) * t):02X}"
        for x, y in zip(a, b)
    )


def grad(stops, n):
    res = []
    for i in range(n):
        p = i / (n - 1) * (len(stops) - 1)
        k = min(int(p), len(stops) - 2)
        res.append(lerp(stops[k], stops[k + 1], p - k))
    return res


def _run(cmd):
    try:
        return subprocess.check_output(cmd, stderr=subprocess.DEVNULL, text=True).strip()
    except Exception:
        return ""


def detect_kde_wallpaper():
    # Plasma 6: kreadconfig6 from plasma-org.kde.plasma.desktop-appletsrc
    for cfg in [
        Path.home() / ".config/plasma-org.kde.plasma.desktop-appletsrc",
        Path.home() / ".config/plasma-org.kde.plasma.desktop-appletsrc.lock",  # unlikely
    ]:
        if not cfg.exists():
            continue
    appletsrc = Path.home() / ".config/plasma-org.kde.plasma.desktop-appletsrc"
    if not appletsrc.exists():
        return None
    # Find Image= under org.kde.image wallpaper plugin
    text = appletsrc.read_text(encoding="utf-8", errors="ignore")
    # Walk groups; pick the last Image= in an org.kde.image/General context
    current_groups = []
    image = None
    for line in text.splitlines():
        m = re.match(r"^\[(.+)\]$", line.strip())
        if m:
            current_groups = m.group(1).split("][")
            continue
        if line.startswith("Image="):
            ctx = "/".join(current_groups)
            if "org.kde.image" in ctx and "General" in ctx:
                image = line.split("=", 1)[1].strip()
    if image:
        return image
    # fallback: any Image=
    m = re.search(r"^Image=(.+)$", text, re.M)
    return m.group(1).strip() if m else None


def resolve_wallpaper_path(image):
    if not image:
        return None
    if image.startswith("file://"):
        image = image[7:]
    p = Path(os.path.expanduser(image))
    if p.is_file():
        return p
    if p.is_dir():
        # KDE wallpaper package: prefer dark variant, then default; pick largest
        for sub in ["contents/images_dark", "contents/images"]:
            d = p / sub
            if d.is_dir():
                imgs = [f for f in d.iterdir() if f.suffix.lower() in {".png", ".jpg", ".jpeg", ".webp"}]
                if imgs:
                    # prefer largest by name heuristic (contains resolution) or file size
                    imgs.sort(key=lambda f: f.stat().st_size, reverse=True)
                    return imgs[0]
        # plain directory of images
        imgs = [f for f in p.iterdir() if f.is_file() and f.suffix.lower() in {".png", ".jpg", ".jpeg", ".webp"}]
        if imgs:
            imgs.sort(key=lambda f: f.stat().st_size, reverse=True)
            return imgs[0]
    return None


def extract_stops(image_path, n=8):
    """Extract n gradient stops from image top->bottom using ImageMagick."""
    if not image_path or not Path(image_path).exists():
        return None, None
    # Sample a small grid: width 64, n bands * 40 rows for enough pixels
    band_rows = 40
    w, h = 64, n * band_rows
    try:
        raw = subprocess.check_output(
            ["magick", str(image_path), "-resize", f"{w}x{h}!", "-depth", "8", "rgb:-"],
            stderr=subprocess.DEVNULL,
        )
    except Exception:
        return None, None
    pixels = list(raw)
    if len(pixels) < w * h * 3:
        return None, None

    def to_lin(c):
        c /= 255
        return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4

    def to_srgb(c):
        v = 12.92 * c if c <= 0.0031308 else 1.055 * c ** (1 / 2.4) - 0.055
        return max(0, min(255, round(v * 255)))

    stops = []
    for b in range(n):
        cand = []
        for y in range(b * band_rows, (b + 1) * band_rows):
            for x in range(w):
                i = (y * w + x) * 3
                r, g, bl = pixels[i], pixels[i + 1], pixels[i + 2]
                h2, l, s = colorsys.rgb_to_hls(r / 255, g / 255, bl / 255)
                # Favor saturated, mid-light colors; avoid near-black/white
                wgt = max(0.0, s) * max(0.0, 1 - abs(l - 0.45) * 2.2)
                if wgt > 0.01:
                    cand.append((wgt, r, g, bl))
        if not cand:
            # fallback: average the band
            rs = gs = bs = cnt = 0
            for y in range(b * band_rows, (b + 1) * band_rows):
                for x in range(w):
                    i = (y * w + x) * 3
                    rs += to_lin(pixels[i]); gs += to_lin(pixels[i + 1]); bs += to_lin(pixels[i + 2]); cnt += 1
            stops.append("#{:02X}{:02X}{:02X}".format(to_srgb(rs / cnt), to_srgb(gs / cnt), to_srgb(bs / cnt)))
            continue
        cand.sort(key=lambda t: t[0], reverse=True)
        top = cand[: max(1, len(cand) // 10)]
        tw = sum(t[0] for t in top)
        r = sum(t[0] * to_lin(t[1]) for t in top) / tw
        g = sum(t[0] * to_lin(t[2]) for t in top) / tw
        bl = sum(t[0] * to_lin(t[3]) for t in top) / tw
        # Slight lightness lift so keys stay readable on dark terminal
        h2, l, s = colorsys.rgb_to_hls(to_srgb(r) / 255, to_srgb(g) / 255, to_srgb(bl) / 255)
        l = min(0.72, max(0.28, l * 1.08 + 0.03))
        s = min(1.0, s * 1.05)
        rr, gg, bb = colorsys.hls_to_rgb(h2, l, s)
        stops.append("#{:02X}{:02X}{:02X}".format(int(rr * 255 + 0.5), int(gg * 255 + 0.5), int(bb * 255 + 0.5)))
    return stops, str(image_path)


def build_config(stops, theme_name):
    gecko = [
        "        ⣀⣤⣴⣶⣾⣿⣿⣿⣿⣿⣿⣶⣶⣦⣤⣰⣶⣶⣤⣤⣀⡀",
        "    ⢀⣤⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢩⡤⢍⢷⡀",
        "  ⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⠿⣧⡘⠿⢛⣼⣧",
        " ⣴⣿⣿⠿⠿⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣭⣙⣋⣩⡄",
        "⣼⣿⡟⠁⣠⣶⣶⣤⡀⠙⢿⣿⣿⣿⠿⠛⠻⠿⣿⣿⣿⣿⠛⠛⠛⠛⠛⠛⠛⠉⠁",
        "⣿⣿⡁⢸⣿⣁⡈⠹⣿⡆⠈⢿⣿⡇    ⠈⠻⣿⣿",
        "⠘⣿⣷⣄⠙⠛⠋⣠⣿⡇  ⠙⠁      ⠈⠙⠣",
        " ⠈⠛⠿⣿⣿⣿⠿⠋",
    ]
    gcol = grad(stops, len(gecko))
    logo = {
        "type": "data",
        "source": "\n".join(f"${i+1}{l}" for i, l in enumerate(gecko)),
        "color": {str(i + 1): c for i, c in enumerate(gcol)},
        "padding": {"top": 5, "left": 1, "right": 2},
    }

    rows = [
        ("  kernel  ", {"type": "kernel", "format": "{release}"}),
        ("  os age  ", {"type": "disk", "folders": "/", "format": "{create-time:10} ({days} days)"}),
        ("󰅐  uptime  ", {"type": "uptime"}),
        ("󰏖  pkgs    ", {"type": "packages"}),
        ("  shell   ", {"type": "shell", "format": "{pretty-name} {version}"}),
        None,
        ("  desktop ", {"type": "de", "format": "{pretty-name} {version}"}),
        ("󰧨  login   ", {"type": "lm", "format": "{pretty-name}"}),
        ("  session ", {"type": "wm", "format": "{pretty-name} · {protocol-name}"}),
        ("  term    ", {"type": "terminal", "format": "{pretty-name} {version}"}),
        None,
        ("󰻠  cpu     ", {"type": "cpu", "format": "{name} · {cores-logical} threads"}),
        ("󰍛  gpu     ", {"type": "gpu", "format": "{name}"}),
        ("󰍹  display ", {"type": "display"}),
        ("󰑭  memory  ", {"type": "memory", "format": f"{{percentage-bar}}  {{percentage}}  {{##{SLATE[1:]}}}{{used}} / {{total}}"}),
        ("  root    ", {"type": "disk", "folders": "/", "format": f"{{size-percentage-bar}}  {{size-percentage}}  {{##{SLATE[1:]}}}{{size-used}} / {{size-total}}"}),
        ("  home    ", {"type": "disk", "folders": "/home", "format": f"{{size-percentage-bar}}  {{size-percentage}}  {{##{SLATE[1:]}}}{{size-used}} / {{size-total}}"}),
        ("  games   ", {"type": "disk", "folders": "/home/throttlemeister/games", "format": f"{{size-percentage-bar}}  {{size-percentage}}  {{##{SLATE[1:]}}}{{size-used}} / {{size-total}}"}),
        ("  wifi    ", {"type": "wifi", "key": "", "format": "{ssid}"}),
        ("󰩟  lan     ", {"type": "localip", "key": "", "compact": True}),
        ("󰩟  wan     ", {"type": "publicip", "key": "", "keyColor": "", "timeout": 1000}),
        ("  power   ", {"type": "battery", "format": f"{{capacity-bar}}  {{capacity}}  {{##{SLATE[1:]}}}{{status}}"}),
    ]
    keyed = [r for r in rows if r]
    kc = grad(stops, len(keyed))
    W = 48
    strip = "".join(f"{{##{c[1:]}}}━" for c in grad(stops, W))
    modules = [
        {"type": "os", "key": " ", "format": f"{{#1}}{{##{AMBER[1:]}}}{{pretty-name}}{{#}}"},
        {"type": "host", "key": " ", "format": f"{{##{SLATE[1:]}}}{{family}}"},
        {"type": "custom", "format": strip + "{#}"},
    ]
    i = 0
    for r in rows:
        if r is None:
            modules.append("break")
            continue
        key, m = r
        m = dict(m)
        m["key"] = key.ljust(8)
        m["keyColor"] = kc[i]
        i += 1
        modules.append(m)

    cfg = {
        "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
        "logo": logo,
        "display": {
            "separator": "  ",
            "color": {"keys": SLATE, "title": FROST, "output": FROST, "separator": SLATE},
            "brightColor": False,
            "showErrors": False,
            "size": {"binaryPrefix": "iec", "ndigits": 1},
            "percent": {"type": ["bar", "num", "num-color", "bar-monochrome"], "ndigits": 0,
                        "color": {"green": TEAL, "yellow": AMBER, "red": CORAL}},
            "bar": {"width": 10, "char": {"elapsed": "■", "total": "■"}, "border": None,
                    "color": {"total": DIM}},
        },
        "modules": modules,
    }
    header = f"""// {theme_name} — fastfetch theme, generated
// Gradient sampled from wallpaper (top to bottom):
// {', '.join(stops)}
// The gecko and the key column share this gradient. Values stay frost-white;
// percentages and bars turn teal -> amber -> red only when something needs attention.
"""
    text = json.dumps(cfg, ensure_ascii=False, indent=2) + "\n"
    text = text.replace(
        '      "type": "packages",\n      "key"',
        '      "type": "packages",\n      //"format": "{rpm} rpm{?flatpak-all} · {flatpak-all} flatpak{?}",\n      "key"',
    )
    return header + text


def main():
    ap = argparse.ArgumentParser(description="Build fastfetch config from wallpaper gradient")
    ap.add_argument("out", help="Output config.jsonc path")
    ap.add_argument("--wallpaper", help="Wallpaper file/dir/URL (file://). Default: detect KDE wallpaper")
    ap.add_argument("--stops", type=int, default=8, help="Number of gradient stops (default: 8)")
    ap.add_argument("--no-detect", action="store_true", help="Do not auto-detect wallpaper; use fallback")
    args = ap.parse_args()

    wallpaper = args.wallpaper
    theme_name = DEFAULT_THEME
    if not wallpaper and not args.no_detect:
        wallpaper = detect_kde_wallpaper()
    resolved = resolve_wallpaper_path(wallpaper) if wallpaper else None
    stops, used = extract_stops(resolved, args.stops)
    if stops:
        name = Path(used).stem
        # try to get a nicer name from wallpaper package
        p = Path(used)
        for parent in p.parents:
            if (parent / "metadata.json").exists() or (parent / "metadata.desktop").exists():
                name = parent.name
                break
        theme_name = f"Wallpaper gradient ({name})"
        print(f"Wallpaper: {used}", file=sys.stderr)
        print(f"Stops: {', '.join(stops)}", file=sys.stderr)
    else:
        stops = list(DEFAULT_STOPS)
        if wallpaper:
            print(f"Warning: could not extract gradient from {wallpaper!r}, using fallback", file=sys.stderr)
        else:
            print("Warning: no wallpaper detected, using fallback", file=sys.stderr)

    out = Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(build_config(stops, theme_name), encoding="utf-8")
    print(f"Wrote {out}", file=sys.stderr)


if __name__ == "__main__":
    main()
