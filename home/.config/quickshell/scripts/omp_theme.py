"""Emit a supported OMP ThemeJson without editing any OMP user settings.

The desktop extension installs its named custom theme and calls ctx.ui.setTheme.
See https://github.com/can1357/oh-my-pi/blob/main/docs/theme.md.
"""
import json
import os
import sys
from pathlib import Path


def emit(palette):
    """Write only Eclipse's generated theme; shared by both palette modes."""
    try:
        background = palette["background"]
        surface = palette["surface"]
        border = palette["border"]
        text = palette["text"]
        muted = palette.get("textMuted", text)
        accent = palette["accent"]
        red, green, yellow, blue = (palette[key] for key in ("red", "green", "yellow", "blue"))
        colors = {}
        groups = [
            (text, "text thinkingText userMessageText customMessageText toolTitle toolOutput assistantMessageText mdCodeBlock toolDiffContext syntaxVariable syntaxOperator syntaxPunctuation"),
            (accent, "accent borderAccent customMessageLabel mdHeading mdLink mdCode mdListBullet syntaxFunction syntaxType thinkingHigh thinkingXhigh thinkingMax statusLineModel statusLineContext statusLineSubagents"),
            (border, "border borderMuted mdCodeBlockBorder mdQuoteBorder mdHr statusLineSep"),
            (muted, "muted dim mdLinkUrl mdQuote syntaxComment thinkingOff statusLinePath"),
            (surface, "selectedBg userMessageBg customMessageBg toolPendingBg toolSuccessBg toolErrorBg"),
            (background, "statusLineBg"),
            (green, "success toolDiffAdded syntaxString thinkingLow statusLineGitClean statusLineStaged"),
            (red, "error toolDiffRemoved statusLineDirty"),
            (yellow, "warning syntaxNumber thinkingMedium statusLineGitDirty statusLineSpend statusLineUntracked statusLineCost"),
            (blue, "syntaxKeyword thinkingMinimal bashMode pythonMode statusLineOutput"),
        ]
        for color, names in groups:
            colors.update({name: color for name in names.split()})
        target = Path(os.environ.get("XDG_CONFIG_HOME") or Path.home() / ".config") / "quickshell" / "omp-theme.json"
        target.parent.mkdir(parents=True, exist_ok=True)
        temporary = target.with_suffix(".json.tmp")
        temporary.write_text(json.dumps({"name": "Eclipse", "colors": colors}, indent=2) + "\n", encoding="utf-8")
        temporary.replace(target)
    except (OSError, KeyError, TypeError, ValueError) as error:
        print(f"OMP theme: {error}", file=sys.stderr)
