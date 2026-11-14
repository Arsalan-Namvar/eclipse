"""Native Strata theme selection must preserve independent app preferences."""
import importlib.util
import json
import pathlib
import subprocess
import sys
import tempfile
import tomllib
import unittest
from unittest.mock import patch

SCRIPTS = pathlib.Path(__file__).parents[1] / 'home/.config/quickshell/scripts'
with patch.object(sys, 'path', [str(SCRIPTS), *sys.path]):
    spec = importlib.util.spec_from_file_location('theme_manager_strata', SCRIPTS / 'theme_manager.py')
    theme = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(theme)

PALETTE = dict(background='#161821', surface='#24283b', text='#e0e6f0', accent='#7aa2f7',
               red='#f7768e', green='#9ece6a', yellow='#e0af68', blue='#7aa2f7')


class StrataTheme(unittest.TestCase):
    def test_selection_preserves_preferences_and_live_theme_replacement(self):
        with tempfile.TemporaryDirectory() as work:
            root = pathlib.Path(work)
            config, state = root / 'config', root / 'state'
            app = config / 'strata'
            app.mkdir(parents=True)
            original = 'mode = "theme"\ntheme = "tokyo-night"\nshow_hidden = true\n[nested]\ntheme = "keep"\n'
            (app / 'settings.toml').write_text(original)
            state.mkdir()
            (state / 'app-palette.json').write_text(json.dumps(PALETTE))
            with patch.object(theme, 'XDG_CONFIG_HOME', str(config)), patch.object(theme, 'STATE_DIR', str(state)), patch.object(theme, 'APP_PALETTE_FILE', str(state / 'app-palette.json')), patch.object(theme.subprocess, 'run', return_value=subprocess.CompletedProcess([], 1)):
                self.assertTrue(theme.prepare_strata_theme())
                saved = tomllib.loads((app / 'settings.toml').read_text())
                self.assertEqual(saved['theme'], 'eclipse')
                self.assertTrue(saved['show_hidden'])
                self.assertEqual(saved['nested']['theme'], 'keep')
                backups = list((state / 'app-backups').glob('strata-theme-*.toml'))
                self.assertEqual(backups[0].read_text(), original)
                path = app / 'themes/eclipse.toml'
                before = tomllib.loads(path.read_text())
                theme.write_strata_theme(dict(PALETTE, background='#f0ece2', surface='#e4ded0', text='#252525', accent='#8a3812'))
                after = tomllib.loads(path.read_text())
                self.assertNotEqual(before['background'], after['background'])
                self.assertNotEqual(before['accent'], after['accent'])
                self.assertEqual(tomllib.loads((app / 'settings.toml').read_text()), saved)

    def test_running_strata_is_not_reconfigured(self):
        with patch.object(theme.subprocess, 'run', return_value=subprocess.CompletedProcess([], 0)), patch.object(theme, 'write_strata_theme') as write:
            self.assertFalse(theme.prepare_strata_theme())
            write.assert_not_called()
