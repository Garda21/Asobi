//
//  SettingsView.swift
//  Asobi
//
//  Created by Brian Dashore on 8/5/21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var navModel: NavigationViewModel

    @AppStorage("useDarkTheme") var useDarkTheme = false
    @AppStorage("followSystemTheme") var followSystemTheme = true
    @AppStorage("navigationAccent") var navigationAccent: Color = .red

    // Core settings. All prefs saved in UserDefaults
    var body: some View {
        NavigationView {
            Form {
                SettingsAppearanceView()
                SettingsBehaviorView()
                SettingsPrivacyView()
                SettingsDownloadsView()
                SettingsWebsiteView()

                // MARK: Credentials and problems

                Section {
                    ListRowTextView(leftText: "Assistenza", rightText: "supporto@gotaac.it")

                    NavigationLink(destination: AboutView()) {
                        Text("Informazioni")
                    }
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: navigationAccent))
            .navigationBarTitle("Impostazioni")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fine") {
                        navModel.currentSheet = nil
                    }
                    .keyboardShortcut(.cancelAction)
                }
            }
        }
        .blur(radius: navModel.blurRadius)
        .applyTheme(followSystemTheme ? nil : (useDarkTheme ? .dark : .light))
        .navigationViewStyle(.stack)
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
#endif
