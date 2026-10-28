-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │                                                                          │
-- │   P R O G R A M S                                                        │
-- │   default applications · consumed by other modules                       │
-- │                                                                          │
-- │   github.com/andreumassanet/impasto                                      │
-- │                                                                          │
-- ╰──────────────────────────────────────────────────────────────────────────╯

-- Single place declaring which program does what. To use it:
--     local apps = require("modules.programs")

return {
    terminal     = "kitty",
    file_manager = "strata",
    browser      = [["$HOME/.local/bin/eclipse-browser"]],
    editor       = "kitty -- nvim",
    agent        = [[bash "$HOME/.config/quickshell/scripts/omp-launch.sh" --general]],
    music        = "spotify",
    messenger    = "Telegram",
}
