import json, sys
out = sys.argv[1]
# Gradient sampled from the current wallpaper (KDE "Next" / Hanabi, dark):
# indigo-violet at the top, through periwinkle and mauve, down to amber.
STOPS = ["#7866AA", "#7478C2", "#7089D2", "#8F7AC0", "#9E8FBC", "#BE8BAE", "#CB8F80", "#D99A55"]

def _to_linear(c):
    c /= 255
    return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4

def _to_srgb(c):
    v = 12.92 * c if c <= 0.0031308 else 1.055 * c ** (1 / 2.4) - 0.055
    return max(0, min(255, round(v * 255)))

def lerp(a, b, t):
    a = [int(a[i:i+2], 16) for i in (1, 3, 5)]
    b = [int(b[i:i+2], 16) for i in (1, 3, 5)]
    # interpolate in linear light so the ramp stays perceptually smooth
    return "#" + "".join(f"{_to_srgb(_to_linear(x) * (1 - t) + _to_linear(y) * t):02X}" for x, y in zip(a, b))

def grad(n):
    res = []
    for i in range(n):
        p = i / (n - 1) * (len(STOPS) - 1); k = min(int(p), len(STOPS) - 2)
        res.append(lerp(STOPS[k], STOPS[k + 1], p - k))
    return res

FROST, SLATE, DIM = "#E2E0EE", "#948CB8", "#3A3152"
AMBER, TEAL, CORAL = "#D99A55", "#82B7B8", "#CC736C"
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
gcol = STOPS  # one stop per gecko row: the gecko follows the wallpaper
logo = {"type": "data",
        "source": "\n".join(f"${i+1}{l}" for i, l in enumerate(gecko)),
        "color": {str(i + 1): c for i, c in enumerate(gcol)},
        "padding": {"top": 5, "left": 1, "right": 2}}

rows = [  # (key, module dict) ; None = blank spacer; keep in sync with config.jsonc
 ("  kernel",  {"type": "kernel", "format": "{release}"}),
 ("󰅐  uptime",  {"type": "uptime"}),
 ("󰏖  pkgs",    {"type": "packages"}),
 ("  shell",   {"type": "shell", "format": "{pretty-name} {version}"}),
 None,
 ("  desktop", {"type": "de", "format": "{pretty-name} {version}"}),
 ("󰧨  login",   {"type": "lm", "format": "{pretty-name}"}),
 ("  session", {"type": "wm", "format": "{pretty-name} · {protocol-name}"}),
 ("  term",    {"type": "terminal", "format": "{pretty-name} {version}"}),
 None,
 ("󰻠  cpu",     {"type": "cpu", "format": "{name} · {cores-logical} threads"}),
 ("󰍛  gpu",     {"type": "gpu", "format": "{name}"}),
 ("󰍹  display", {"type": "display"}),
 ("󰑭  memory",  {"type": "memory", "format": f"{{percentage-bar}}  {{percentage}}  {{##{SLATE[1:]}}}{{used}} / {{total}}"}),
 ("  root",    {"type": "disk", "folders": "/", "format": f"{{size-percentage-bar}}  {{size-percentage}}  {{##{SLATE[1:]}}}{{size-used}} / {{size-total}}"}),
 ("  home",    {"type": "disk", "folders": "/home", "format": f"{{size-percentage-bar}}  {{size-percentage}}  {{##{SLATE[1:]}}}{{size-used}} / {{size-total}}"}),
 ("  games",   {"type": "disk", "folders": "/home/throttlemeister/games", "format": f"{{size-percentage-bar}}  {{size-percentage}}  {{##{SLATE[1:]}}}{{size-used}} / {{size-total}}"}),
 ("󰩟  lan",     {"type": "localip", "key": "", "compact": True}),
 ("  wifi",    {"type": "wifi", "key": "", "format": "{ssid}"}),
 ("󰩟  wan",     {"type": "publicip", "key": "", "keyColor": "", "timeout": 1000}),
 ("  power",   {"type": "battery", "format": f"{{capacity-bar}}  {{capacity}}  {{##{SLATE[1:]}}}{{status}}"}),
]
keyed = [r for r in rows if r]
kc = grad(len(keyed))
W = 48
strip = "".join(f"{{##{c[1:]}}}━" for c in grad(W))
modules = [
 {"type": "os", "key": " ", "format": f"{{#1}}{{##{AMBER[1:]}}}{{pretty-name}}{{#}}"},
 {"type": "host", "key": " ", "format": f"{{##{SLATE[1:]}}}{{family}}"},
 {"type": "custom", "format": strip + "{#}"},
]
i = 0
for r in rows:
    if r is None:
        modules.append("break"); continue
    key, m = r
    m = dict(m); m["key"] = key.ljust(8); m["keyColor"] = kc[i]; i += 1
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
header = """// "Hanabi" (KDE Next, dark) — fastfetch theme, updated 2026-11-19
// The gecko and the key column share one gradient sampled from the wallpaper:
// deep indigo-violet at the top, through periwinkle and mauve, down to amber.
// A matching horizon line sits under the header. Values stay frost-white;
// percentages and bars turn teal -> amber -> red only when something needs attention.
// No Nerd Font icons needed. 17 rows, fits a ~100x20 terminal.
"""
text = json.dumps(cfg, ensure_ascii=False, indent=2) + "\n"
# keep the alternate packages format documented, but disabled
text = text.replace('      "type": "packages",\n      "key"',
                    '      "type": "packages",\n      //"format": "{rpm} rpm{?flatpak-all} · {flatpak-all} flatpak{?}",\n      "key"')
open(out, "w", encoding="utf-8").write(header + text)
