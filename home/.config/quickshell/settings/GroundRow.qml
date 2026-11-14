// ╭──────────────────────────────────────────────────────────────────────────╮
// │                                                                          │
// │   G R O U N D   R O W                                                    │
// │   settings · what one layer is made of, classic, glass or liquid         │
// │                                                                          │
// │   github.com/andreumassanet/impasto                                      │
// │                                                                          │
// ╰──────────────────────────────────────────────────────────────────────────╯

import QtQuick

import "../theme"
import "../services"
import "../components"

// The two material layers share the same choices, not the same rendering.
SettingRow {
    id: root

    // The setting that holds it: windowMaterial or surfaceStyle.
    required property string key

    readonly property string value: SettingsService[root.key]

    label: Tr.t("Material")
    reading: root.key === "windowMaterial"
        ? (root.value === "classic" ? Tr.t("Opaque · no blur or refraction")
           : root.value === "glass" ? Tr.t("90% opacity · blur")
           : Tr.t("75% opacity · blur · optional refraction"))
        : (root.value === "classic" ? Tr.t("Solid native surfaces")
           : root.value === "glass" ? Tr.t("Tinted native glass")
           : Tr.t("Clear native frosted glass"))

    SegmentedControl {
        options: [
            { id: "classic", label: Tr.t("Classic") },
            { id: "glass", label: Tr.t("Glass") },
            { id: "liquid", label: Tr.t("Liquid") }
        ]
        current: root.value
        onSelected: id => SettingsService.set(root.key, id)
    }
}
