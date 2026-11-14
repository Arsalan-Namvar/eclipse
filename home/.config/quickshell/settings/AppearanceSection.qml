// ╭──────────────────────────────────────────────────────────────────────────╮
// │                                                                          │
// │   A P P E A R A N C E   S E C T I O N                                    │
// │   appearance · palette, windows, fonts and motion                        │
// │                                                                          │
// │   github.com/andreumassanet/impasto                                      │
// │                                                                          │
// ╰──────────────────────────────────────────────────────────────────────────╯

import QtQuick
import QtQuick.Layouts

import "../theme"
import "../services"
import "../components"

// Wallpaper, the two material layers, type and the shell's motion.
// Window layout and animation live in `WindowsSection`.
SettingsSection {
    id: root

    // The visible part; set by `SettingsPanel`.
    property string tab: ""

    signal panelRequested(string panel)

    Component.onCompleted: FontService.load()

    // ── WALLPAPER ───────────────────────────────────────────────────────────

    ColumnLayout {
        Layout.fillWidth: true
        spacing: root.spacing
        visible: root.tab === "wallpaper"

        // Theme and wallpaper are chosen in the island's appearance panel;
        // this row only opens it.
        SettingGroup {
            title: Tr.t("Theme")
            note: Tr.t("The palette follows the wallpaper, and both are chosen in the island.")
            hint: Tr.t("This opens the island's appearance panel, where wallpapers and palettes are chosen together.")

            SettingRow {
                label: Tr.t("Theme and wallpaper")
                reading: Theme.activeName

                PillButton {
                    text: Tr.t("Open")
                    icon: "󰏘"
                    active: true
                    implicitWidth: 92
                    implicitHeight: 30
                    onClicked: root.panelRequested("appearance")
                }
            }
        }

        // Each tile loops its awww transition in miniature.
        SettingGroup {
            title: Tr.t("Transition")
            note: Tr.t("How the next wallpaper arrives over the last one.")
            hint: Tr.t("Random picks one of the effects above each time a wallpaper is applied.")

            SettingTiles {
                label: Tr.t("Effect")

                Repeater {
                    model: WallpaperService.transitions

                    PreviewTile {
                        id: transitionTile

                        required property var modelData

                        stageHeight: 52
                        caption: Tr.t(transitionTile.modelData.label)
                        selected: SettingsService.wallpaperTransition === transitionTile.modelData.id
                        onPicked: SettingsService.set("wallpaperTransition", transitionTile.modelData.id)

                        WallpaperTransitionPreview {
                            anchors.centerIn: parent
                            effect: transitionTile.modelData.id
                        }
                    }
                }
            }
        }
    }

    // ── MATERIALS ──────────────────────────────────────────────────────────

    ColumnLayout {
        Layout.fillWidth: true
        spacing: root.spacing
        visible: root.tab === "materials"

        SettingGroup {
            title: Tr.t("Application windows")
            note: Tr.t("One compositor-controlled material for ordinary application windows.")
            hint: Tr.t("Classic is opaque. Glass uses 90% opacity and blur; Liquid uses 75% and optional refraction (./setup plugins). The whole window fades. Image/video viewers, screenshot editing, fullscreen and reported photo/video surfaces stay opaque and unrefracted. Embedded browser media still shares the normal browser window's material; fullscreen protects the whole window. Quickshell is separate. Game mode temporarily uses Classic.")

            GroundRow {
                key: "windowMaterial"
            }
        }

        SettingGroup {
            title: Tr.t("Quickshell")
            note: Tr.t("Native materials for the bar, island and shell panels.")
            hint: Tr.t("Classic is solid, Glass is tinted and blurred, and Liquid is a clear frosted pane. These native shell surfaces keep text and icons opaque and are independent of application windows. Shell Liquid does not require the window-glass plugin.")

            GroundRow {
                key: "surfaceStyle"
            }
        }
    }

    // ── TYPE ────────────────────────────────────────────────────────────────
    //
    // Families come from fontconfig: Qt silently substitutes a family that is
    // not installed, so a typed name could look applied when it is not.

    ColumnLayout {
        Layout.fillWidth: true
        spacing: root.spacing
        visible: root.tab === "type"

        SettingGroup {
            title: Tr.t("Interface")
            note: Tr.t("Everything Quickshell draws.")

            SettingBlock {
                padding: 6

                FontPicker {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 132
                    families: FontService.sans
                    current: SettingsService.fontFamily
                    sample: "The quick brown fox 0123"
                    onPicked: family => SettingsService.set("fontFamily", family)
                }
            }
        }

        SettingGroup {
            title: Tr.t("Monospace")
            note: Tr.t("The bar's glyphs and readings, and the terminal.")
            hint: Tr.t("kitty is given the same family, so the terminal and the shell always match. It must be a Nerd Font, or the bar's icons show as empty boxes.")

            SettingBlock {
                padding: 6

                FontPicker {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 132
                    families: FontService.mono
                    current: SettingsService.fontMono
                    sample: "il1 O0 {} => 0123"
                    warning: Tr.t("Icons need a Nerd Font patched family.")
                    onPicked: family => SettingsService.set("fontMono", family)
                }
            }
        }
    }

    // ── MOTION ──────────────────────────────────────────────────────────────
    //
    // The shell's own pace; the windows' animation is Hyprland's, on the
    // Windows page, and neither can use the other's curves.

    ColumnLayout {
        Layout.fillWidth: true
        spacing: root.spacing
        visible: root.tab === "motion"

        SettingGroup {
            title: Tr.t("Game mode")
            note: Tr.t("Everything still, for a game or a slow machine.")
            hint: Tr.t("Stops the shell's animations and the spectrum, makes the island solid without shadows, and temporarily gives application windows Classic material without animations or shadows. Your material and motion choices are kept and restored when it is turned off.")

            SettingRow {
                label: Tr.t("Game mode")
                reading: ShortcutService.current("Shell · Turn game mode on or off")

                ToggleSwitch {
                    checked: SettingsService.gameMode
                    onToggled: checked => SettingsService.set("gameMode", checked)
                }
            }
        }

        SettingGroup {
            title: Tr.t("The shell")
            note: Tr.t("The island, its panels, the chips — everything Qt draws.")

            // Named only when no preset matches, since the chosen tile
            // already says which it is.
            SettingTiles {
                label: Tr.t("Pace")
                reading: Theme.motionPresets.some(
                    row => row.scale === SettingsService.motionScale
                        && row.curve === SettingsService.motionCurve) ? "" : Tr.t("Custom")

                Repeater {
                    model: Theme.motionPresets

                    PreviewTile {
                        id: shellTile

                        required property var modelData

                        stageHeight: 52
                        caption: Tr.t(shellTile.modelData.label)
                        selected: SettingsService.motionScale === shellTile.modelData.scale
                            && SettingsService.motionCurve === shellTile.modelData.curve
                        onPicked: {
                            SettingsService.set("motionScale", shellTile.modelData.scale)
                            SettingsService.set("motionCurve", shellTile.modelData.curve)
                        }

                        IslandMotionPreview {
                            anchors.centerIn: parent
                            preset: shellTile.modelData
                        }
                    }
                }
            }
        }
    }
}
