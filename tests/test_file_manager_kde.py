"""KDE palette generation preserves preferences and uses supported scheme files."""
import configparser
import importlib.util
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

SCRIPTS = Path(__file__).parents[1] / "home/.config/quickshell/scripts"
with patch.object(sys, "path", [str(SCRIPTS), *sys.path]):
    spec = importlib.util.spec_from_file_location("theme_manager_kde", SCRIPTS / "theme_manager.py")
    theme = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(theme)


def read_config(path):
    parser = configparser.RawConfigParser(strict=False)
    parser.optionxform = str
    parser.read(path)
    return parser


class KDEPalette(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.config = self.root / "config"
        self.config.mkdir()
        self.globals = self.config / "kdeglobals"
        self.qtconfig = self.config / "qt6ct/qt6ct.conf"
        self.qtcolors = self.config / "qt6ct/colors/impasto.conf"
        for key, path in (("KDEGLOBALS_FILE", self.globals),
                          ("QT6CT_CONFIG_FILE", self.qtconfig),
                          ("QT6CT_COLORS_FILE", self.qtcolors)):
            patcher = patch.object(theme, key, str(path))
            patcher.start()
            self.addCleanup(patcher.stop)
        patcher = patch.object(theme.shutil, "which", side_effect=lambda name: "/usr/bin/" + name)
        patcher.start()
        self.addCleanup(patcher.stop)

    def test_two_palettes_keep_unrelated_kde_preferences(self):
        self.globals.write_text("[General]\nTerminalApplication=kitty\nCustom=100%\n"
                                "[Icons]\nTheme=custom-icons\n"
                                "[Colors:View]\nCustomRole=keep\n")
        for accent in ("#e03070", "#3080e0"):
            theme.write_qt_theme({"accent": accent, "background": "#202020"})
            globals_config = read_config(self.globals)
            self.assertEqual(globals_config["General"]["TerminalApplication"], "kitty")
            self.assertEqual(globals_config["General"]["Custom"], "100%")
            self.assertEqual(globals_config["Icons"]["Theme"], "custom-icons")
            self.assertEqual(globals_config["Colors:View"]["CustomRole"], "keep")

    def test_malformed_user_files_are_left_untouched(self):
        self.globals.write_text("not a config section\n")
        with patch.object(theme.sys, "stderr"):
            theme.write_kde_colors({"accent": "#3080e0"})
        self.assertEqual(self.globals.read_text(), "not a config section\n")



if __name__ == "__main__":
    unittest.main()
