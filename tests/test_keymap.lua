-- Behavior boundaries for profile migration; run from the repository root.
package.path = "home/.config/hypr/?.lua;" .. package.path
local keymap = require("modules.keymap")

local legacy = {
    ["Shell · Open the notes"] = "SUPER + S",
    ["Shell · Open the capture surface"] = "SUPER + SHIFT + S",
    ["Utilities · Restart the shell"] = "SUPER + CTRL + R",
    ["Applications · Open a terminal"] = "control + meta + t",
    ["Shell · Capture a region"] = "",
    ["Personal · Unrelated command"] = "SUPER + ALT + Z",
    ["Shell · Open the games"] = "SUPER + ALT + G",
}
local migrated = keymap.migrate(legacy, 0)
assert(migrated["Shell · Open the notes"] == nil, "inherited Notes key must follow the new default")
assert(migrated["Shell · Open the capture surface"] == nil, "inherited Capture key must not collide with scratchpad send")
assert(migrated["Utilities · Restart the shell"] == nil, "inherited restart chord must be released for recording")
assert(migrated["Applications · Open a terminal"] == "control + meta + t", "custom binding must survive")
assert(migrated["Shell · Open the palette"] == "", "custom wins over the new palette default regardless modifier spelling")
assert(migrated["Shell · Capture a region"] == "", "explicitly unbound action must stay unbound")
assert(migrated["Personal · Unrelated command"] == legacy["Personal · Unrelated command"], "unrelated custom action must survive")
assert(migrated["Shell · Open the games"] == nil, "retired action must disappear")
assert(legacy["Shell · Open the notes"] == "SUPER + S", "migration must not mutate input")

local current = keymap.migrate({ ["Shell · Open the notes"] = "SUPER + S" }, keymap.version)
assert(current["Shell · Open the notes"] == "SUPER + S", "post-migration customization must not be remigrated")

local path = os.tmpname()
local file = assert(io.open(path, "w"))
file:write("Shell · Open the notes\tSUPER + S\nShell · Open the capture surface\tSUPER + SHIFT + S\n")
file:close()
local effective = keymap.load(path)
os.remove(path)
assert(effective["Shell · Open the notes"] == "SUPER + SHIFT + N")
assert(effective["Shell · Open the capture surface"] == "SUPER + CTRL + C")
assert(effective["Workspaces · Toggle the scratchpad"] == "SUPER + S")
assert(effective["Workspaces · Move the window to the scratchpad"] == "SUPER + SHIFT + S")

print("Keyboard migration: legacy cutover, custom precedence, retirement, version and first-boot TSV passed")
