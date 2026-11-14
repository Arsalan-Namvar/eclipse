-- Media accuracy is an exception to application material, not another choice.
-- Reassert after the generic material rule so runtime changes cannot fade it.
local M = {}

function M.apply()
    local matches = {
        { class = "^(imv|imv-wayland|mpv|com\\.gabm\\.satty)$" },
        { content = "photo" },
        { content = "video" },
        -- True fullscreen, not maximized windows. Includes browser video/PDF.
        { fullscreen_state_internal = 2 },
    }
    for index, match in ipairs(matches) do
        hl.window_rule({
            name = "eclipse-media-accuracy-" .. index,
            match = match,
            opacity = "1.0 override 1.0 override 1.0 override",
            no_blur = true,
            no_dim = true,
            tag = "+hyprglass_disabled",
        })
    end
end

return M
