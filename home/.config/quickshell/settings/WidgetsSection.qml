// ╭──────────────────────────────────────────────────────────────────────────╮
// │                                                                          │
// │   W I D G E T S   S E C T I O N                                          │
// │   screen edges · note decks, audio spectrum and when they leave           │
// │                                                                          │
// │   github.com/andreumassanet/impasto                                      │
// │                                                                          │
// ╰──────────────────────────────────────────────────────────────────────────╯

import QtQuick
import QtQuick.Layouts

import "../theme"
import "../services"
import "../components"

// Note decks and the audio spectrum are configured on the screen edges.
// The editor controls their placement; this page controls when they hide.
SettingsSection {
    id: root

    // Unused: this page has no parts, but `SettingsPanel` sets it on all pages.
    property string tab: ""

    // `SettingsPanel` closes the window on this.
    signal arranging()

    SettingGroup {
        title: Tr.t("Screen edges")
        note: Tr.t("Note decks and an audio spectrum along the screen edges.")
        hint: Tr.t("Edit opens the edge controls for adding, moving and configuring note decks and the spectrum. Escape leaves the editor. This window closes meanwhile.")

        SettingRow {
            label: Tr.t("Configure the edges")

            PillButton {
                text: Tr.t("Edit")
                implicitHeight: 30
                onClicked: {
                    DesktopService.edit(true)
                    root.arranging()
                }
            }
        }
    }

    SettingGroup {
        title: Tr.t("Behaviour")
        note: Tr.t("What makes way when a window opens on the workspace.")
        hint: Tr.t("The notes stuck on the screen's edges and the spectrum's bars leave when a window opens and come back when the last one closes; the spectrum stops listening meanwhile. Off, the notes stay over the windows and the bars under them.")

        SettingRow {
            label: Tr.t("Notes on the edges")
            reading: SettingsService.deckOnEmpty
                ? Tr.t("Gone while a window is open") : Tr.t("Over the windows")

            ToggleSwitch {
                checked: SettingsService.deckOnEmpty
                onToggled: checked => SettingsService.set("deckOnEmpty", checked)
            }
        }

        SettingRow {
            label: Tr.t("Spectrum")
            reading: SettingsService.spectrumOnEmpty
                ? Tr.t("Gone while a window is open") : Tr.t("Under the windows")

            ToggleSwitch {
                checked: SettingsService.spectrumOnEmpty
                onToggled: checked => SettingsService.set("spectrumOnEmpty", checked)
            }
        }
    }
}
