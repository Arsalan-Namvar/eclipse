// ╭──────────────────────────────────────────────────────────────────────────╮
// │                                                                          │
// │   M O D U L E S   S E C T I O N                                          │
// │   modules · what they know, wherever they are shown                      │
// │                                                                          │
// │   github.com/andreumassanet/impasto                                      │
// │                                                                          │
// ╰──────────────────────────────────────────────────────────────────────────╯

import QtQuick
import QtQuick.Layouts

import "../theme"
import "../services"
import "../components"

// The modules' own settings are shared by bar chips and panels.
SettingsSection {
    id: root

    // Unused: this page has no parts, but `SettingsPanel` sets it on all pages.
    property string tab: ""

    SettingGroup {
        title: Tr.t("Weather")
        note: Tr.t("A city, a postcode or an airport code.")
        hint: Tr.t("Left empty, wttr.in guesses from your connection's IP address, which can be far off. A city, postcode or airport code is more reliable, and the bar uses the same place.")

        // wttr.in answers an unknown place with prose and the widget
        // keeps its last reading, so the error is shown here.
        SettingField {
            label: Tr.t("Location")
            reading: WeatherService.placeUnknown
                ? Tr.t("No such place — the last reading is still showing") : ""
            alarm: WeatherService.placeUnknown
            placeholder: Tr.t("Wherever the request comes from")
            value: SettingsService.weatherPlace
            onEdited: value => SettingsService.set("weatherPlace", value.trim())
        }
    }

    SettingGroup {
        title: "GitHub"
        note: Tr.t("Whose public contribution graph to draw.")
        hint: Tr.t("The graph is read from the public profile page, so no token or account is needed. It stays empty until you enter a username.")

        // An unknown user returns a page with no calendar and the widget
        // keeps its last grid, so the error is shown here.
        SettingField {
            label: Tr.t("Username")
            reading: GithubService.userUnknown
                ? Tr.t("No such profile — the last grid is still showing") : ""
            alarm: GithubService.userUnknown
            placeholder: Tr.t("Nobody yet")
            value: SettingsService.githubUser
            onEdited: value => SettingsService.set(
                "githubUser", value.trim().replace(/^@/, ""))
        }
    }

    SettingGroup {
        title: Tr.t("Lyrics")
        note: Tr.t("The words of whatever is playing, wherever they are shown.")
        hint: Tr.t("Looked up on lrclib.net by title and artist, which needs no account. They show in the island's glance and its media card, and on the lock screen when it is set to show them.")

        SettingRow {
            label: Tr.t("Look them up")
            reading: SettingsService.lyrics
                ? Tr.t("The playing track's lyrics are looked up on lrclib.net")
                : Tr.t("No lyrics, and nothing is looked up")

            ToggleSwitch {
                checked: SettingsService.lyrics
                onToggled: checked => SettingsService.set("lyrics", checked)
            }
        }
    }

    SettingGroup {
        title: Tr.t("Notes")
        note: Tr.t("A note on the wallpaper is written the same way as one in the panel.")

        SettingRow {
            label: Tr.t("Handwriting")
            reading: SettingsService.notesHandwriting
                ? Tr.t("The signature's script") : Tr.t("The interface face")

            ToggleSwitch {
                checked: SettingsService.notesHandwriting
                onToggled: checked => SettingsService.set("notesHandwriting", checked)
            }
        }
    }
}
