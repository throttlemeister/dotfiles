import json, sys
out = sys.argv[1]
# Sky-to-horizon gradient sampled from the dusk wallpaper (blue sky -> mauve -> amber -> ember)
STOPS = ["#5E7690", "#7383A0", "#8A88A6", "#A3889C", "#BE8A89", "#D59072", "#E69C58", "#EC8340"]
def lerp(a, b, t):
    a = [int(a[i:i+2], 16) for i in (1, 3, 5)]; b = [int(b[i:i+2], 16) for i in (1, 3, 5)]
    return "#" + "".join(f"{round(x + (y - x) * t):02X}" for x, y in zip(a, b))
def grad(n):
    res = []
    for i in range(n):
        p = i / (n - 1) * (len(STOPS) - 1); k = min(int(p), len(STOPS) - 2)
        res.append(lerp(STOPS[k], STOPS[k + 1], p - k))
    return res

FROST, SLATE, DIM = "#DCE4EC", "#8492A3", "#3E4A5A"
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
gcol = STOPS  # one stop per gecko row: the gecko is the sunset
logo = {"type": "data",
        "source": "\n".join(f"${i+1}{l}" for i, l in enumerate(gecko)),
        "color": {str(i + 1): c for i, c in enumerate(gcol)},
        "padding": {"top": 5, "left": 1, "right": 2}}

rows = [  # (key, module dict) ; None = blank spacer
 ("kernel",  {"type": "kernel", "format": "{release}"}),
 ("uptime",  {"type": "uptime"}),
 ("pkgs",    {"type": "packages", "format": "{rpm} rpm{?flatpak-all} · {flatpak-all} flatpak{?}"}),
 ("shell",   {"type": "shell", "format": "{pretty-name} {version}"}),
 None,
 ("desktop", {"type": "de", "format": "{pretty-name} {version}"}),
 ("session", {"type": "wm", "format": "{pretty-name} · {protocol-name}"}),
 ("term",    {"type": "terminal", "format": "{pretty-name} {version}"}),
 None,
 ("cpu",     {"type": "cpu", "format": "{name} · {cores-logical} threads"}),
 ("gpu",     {"type": "gpu", "format": "{name}"}),
 ("memory",  {"type": "memory", "format": "{percentage-bar}  {percentage}  {##8492A3}{used} / {total}"}),
 ("disk",    {"type": "disk", "folders": "/", "format": "{size-percentage-bar}  {size-percentage}  {##8492A3}{size-used} / {size-total}"}),
 ("power",   {"type": "battery", "format": "{capacity-bar}  {capacity}  {##8492A3}{status}"}),
]
keyed = [r for r in rows if r]
kc = grad(len(keyed))
W = 46
strip = "".join(f"{{##{c[1:]}}}━" for c in grad(W))
modules = [
 {"type": "os", "key": " ", "format": "{#1}{##E69C58}{pretty-name}{#}"},
 {"type": "host", "key": " ", "format": "{##8492A3}{family}"},
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
              "color": {"green": "#83B7AD", "yellow": "#E69C58", "red": "#D9776B"}},
  "bar": {"width": 10, "char": {"elapsed": "■", "total": "■"}, "border": None,
          "color": {"total": DIM}},
 },
 "modules": modules,
}
header = """// "Skumring over Bleik" — fastfetch by Claude, 2026-11-17
// The gecko and the key column share one gradient sampled from the wallpaper:
// dusk-blue sky at the top, through mauve, down to the ember-orange horizon.
// A matching horizon line sits under the header. Values stay frost-white;
// percentages and bars turn teal -> amber -> red only when something needs attention.
// No Nerd Font icons needed. 17 rows, fits a ~100x20 terminal.
"""
open(out, "w", encoding="utf-8").write(header + json.dumps(cfg, ensure_ascii=False, indent=2) + "\n")
