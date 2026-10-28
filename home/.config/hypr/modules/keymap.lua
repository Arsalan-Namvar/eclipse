-- Shared accepted defaults and saved-profile migration. Descriptions are the
-- stable identifiers used by Hyprland, QML profiles and keys.tsv.
local M = { version = 1 }

local source = debug.getinfo(1, "S").source
local directory = assert(source:match("^@(.*/)"), "Cannot locate the keyboard map module")
local map_file = assert(io.open(directory .. "../keymap.tsv"), "Cannot read the Eclipse keyboard map")
local rows = {}
for line in map_file:lines() do
    local description, combination, legacy = line:match("^([^#\t][^\t]*)\t([^\t]*)\t?(.*)$")
    if description then
        local inherited = {}
        for old in legacy:gmatch("[^|]+") do
            inherited[#inherited + 1] = old
        end
        rows[#rows + 1] = { description = description, combination = combination, legacy = inherited }
    end
end
map_file:close()

local function trim(value)
    return value:match("^%s*(.-)%s*$")
end

function M.normalize(combination)
    local parts = {}
    for part in combination:upper():gmatch("[^+]+") do
        parts[#parts + 1] = trim(part)
    end
    local key = table.remove(parts) or ""
    for index, part in ipairs(parts) do
        if part == "CONTROL" then
            parts[index] = "CTRL"
        elseif part == "MOD4" or part == "META" then
            parts[index] = "SUPER"
        end
    end
    table.sort(parts)
    parts[#parts + 1] = key
    return table.concat(parts, "+")
end

function M.defaults()
    local defaults = {}
    for _, row in ipairs(rows) do
        defaults[row.description] = row.combination == "@removed" and "" or row.combination
    end
    return defaults
end

function M.migrate(overrides, version)
    local next_keys = {}
    for description, combination in pairs(overrides or {}) do
        if type(combination) == "string" then
            next_keys[description] = combination
        end
    end
    for _, row in ipairs(rows) do
        if row.combination == "@removed" then
            next_keys[row.description] = nil
        end
    end
    if (version or 0) >= M.version then
        return next_keys
    end
    for _, row in ipairs(rows) do
        local kept = next_keys[row.description]
        if row.combination == "@removed" then
            next_keys[row.description] = nil
        elseif kept and kept ~= "" then
            for _, old in ipairs(row.legacy) do
                if M.normalize(old) == M.normalize(kept) then
                    next_keys[row.description] = nil
                    break
                end
            end
        end
    end
    local descriptions = {}
    for description in pairs(next_keys) do
        descriptions[#descriptions + 1] = description
    end
    table.sort(descriptions)
    local custom = {}
    for _, description in ipairs(descriptions) do
        if next_keys[description] ~= "" then
            custom[M.normalize(next_keys[description])] = description
        end
    end
    for _, row in ipairs(rows) do
        if row.combination ~= "" and row.combination ~= "@removed"
                and next_keys[row.description] == nil then
            local winner = custom[M.normalize(row.combination)]
            if winner then
                next_keys[row.description] = ""
                io.stderr:write("Keyboard map migration: kept custom ", winner,
                    " on ", row.combination, "; left ", row.description, " unbound\n")
            end
        end
    end
    return next_keys
end

-- Returns the complete effective map without writing user state. The shell
-- persists the same migration later, after reading settings.json. Relative
-- source lookup keeps a nested checkout independent of installed config.
function M.load(profile_path)
    if not profile_path then
        local state = os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")
        profile_path = state .. "/quickshell/keys.tsv"
    end
    local overrides, version = {}, 0
    local file = io.open(profile_path)
    if file then
        for line in file:lines() do
            local marker = line:match("^# eclipse%-keymap=(%d+)$")
            if marker then
                version = tonumber(marker)
            end
            local description, combination = line:match("^([^#\t][^\t]*)\t(.*)$")
            if description then
                overrides[description] = combination
            end
        end
        file:close()
    end
    local effective = M.defaults()
    for description, combination in pairs(M.migrate(overrides, version)) do
        effective[description] = combination
    end
    -- Retired actions cannot be revived by stale or hand-edited overrides.
    for _, row in ipairs(rows) do
        if row.combination == "@removed" then
            effective[row.description] = ""
        end
    end
    return effective
end

return M
