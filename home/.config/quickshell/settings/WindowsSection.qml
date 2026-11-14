// ╭──────────────────────────────────────────────────────────────────────────╮
// │                                                                          │
// │   W I N D O W S   S E C T I O N                                          │
// │   windows · layout, shape, depth and animation                           │
// │                                                                          │
// │   github.com/andreumassanet/impasto                                      │
// │                                                                          │
// ╰──────────────────────────────────────────────────────────────────────────╯

import QtQuick
import QtQuick.Layouts

import "../theme"
import "../services"
import "../components"

// Window layout, shape, shadow and motion. The two material selectors are
// under Appearance; this page never overrides their opacity or effects.
//
// These values are stored in the shell's settings and pushed to Hyprland at
// login and after every reload. `hypr/modules/look.lua` holds the defaults
// and is never written.
SettingsSection {
    id: root

    // Unused: this page has no parts, but `SettingsPanel` sets it on all pages.
    property string tab: ""

    Component.onCompleted: {
        CompositorService.load()
        CompositorService.loadGlass()
    }

    // The stored value first, the compositor's second: `remember` stores on
    // every drag step while the push to Hyprland is coalesced, so reading the
    // compositor back would lag the slider.
    function live(option: string, fallback: real): real {
        const kept = SettingsService.compositor
        if (kept && kept[option] !== undefined)
            return Number(kept[option])
        return Number(CompositorService.value(option, fallback))
    }

    readonly property string material: SettingsService.gameMode
        ? "classic" : SettingsService.windowMaterial

    SettingGroup {
        title: Tr.t("Shape")
        note: Tr.t("How Hyprland draws every window, this one included.")
        hint: Tr.t("Dwindle splits the space each new window lands in, Master keeps one large window beside a stack, and Scrolling lays windows in a row wider than the screen. The preview below is live and at full size. The border stays at zero because gaps and rounding already separate windows; the inner gap applies to each side of a window, so two windows sit twice that apart.")

        SettingBlock {
            WindowsPreview {
                Layout.fillWidth: true
                rounding: root.live("decoration:rounding", 22)
                borderWidth: root.live("general:border_size", 0)
                gapsIn: root.live("general:gaps_in", 7)
                gapsOut: root.live("general:gaps_out", 18)
                inactiveOpacity: root.material === "classic" ? 1
                    : root.material === "glass" ? 0.90 : 0.75
                blur: root.material === "classic" ? 0 : root.live("decoration:blur:size", 6)
                glassed: root.material === "liquid" && CompositorService.glassAvailable
                lifted: SettingsService.windowShadow && !SettingsService.gameMode
                wallpaper: WallpaperService.currentWallpaper
            }
        }

        SettingRow {
            label: Tr.t("Layout")

            SegmentedControl {
                options: CompositorService.windowLayouts.map(
                    entry => ({ id: entry.id, label: Tr.t(entry.label) }))
                current: CompositorService.windowLayout
                onSelected: id => CompositorService.remember("general:layout", id)
            }
        }

        SettingSlider {
            label: Tr.t("Window rounding")
            value: CompositorService.value("decoration:rounding", 22)
            from: 0
            to: 30
            unit: " px"
            onMoved: value => CompositorService.remember("decoration:rounding", Math.round(value))
        }

        SettingSlider {
            label: Tr.t("Border width")
            value: CompositorService.value("general:border_size", 0)
            from: 0
            to: 6
            reading: CompositorService.value("general:border_size", 0) === 0
                ? Tr.t("None") : `${CompositorService.value("general:border_size", 0)} px`
            onMoved: value => CompositorService.remember("general:border_size", Math.round(value))
        }

        SettingSlider {
            label: Tr.t("Inner gap")
            value: CompositorService.value("general:gaps_in", 7)
            from: 0
            to: 20
            unit: " px"
            onMoved: value => CompositorService.remember("general:gaps_in", Math.round(value))
        }

        SettingSlider {
            label: Tr.t("Outer gap")
            value: CompositorService.value("general:gaps_out", 18)
            from: 0
            to: 40
            unit: " px"
            onMoved: value => CompositorService.remember("general:gaps_out", Math.round(value))
        }
    }

    SettingGroup {
        title: Tr.t("Shadow")
        note: Tr.t("What lifts a window off the wallpaper.")
        hint: Tr.t("Application opacity, blur and refraction follow Appearance → Materials → Application windows.")

        SettingRow {
            label: Tr.t("Shadow")
            reading: SettingsService.windowShadow
                ? Tr.t("Lifted off the wallpaper") : Tr.t("Flat")

            ToggleSwitch {
                checked: SettingsService.windowShadow
                onToggled: checked => SettingsService.set("windowShadow", checked)
            }
        }
    }

    // The hint describes every preset, built from `Motion.presets`.
    SettingGroup {
        title: Tr.t("Animation")
        note: Tr.t("How Hyprland animates windows. Reapplied after every reload.")
        hint: Motion.presets.map(
            entry => `${Tr.t(entry.label)} — ${Tr.t(entry.note)}`).join(" ")

        SettingTiles {
            label: Tr.t("Preset")

            Repeater {
                model: Motion.presets

                PreviewTile {
                    id: tile

                    required property var modelData

                    stageHeight: 52
                    caption: Tr.t(tile.modelData.label)
                    selected: SettingsService.animationPreset === tile.modelData.id
                    onPicked: SettingsService.set("animationPreset", tile.modelData.id)

                    MotionPreview {
                        anchors.centerIn: parent
                        width: parent.width - 22
                        preset: tile.modelData
                    }
                }
            }
        }
    }
}
