//
//  SettingsWebsiteView.swift
//  Asobi
//
//  Created by Brian Dashore on 4/9/22.
//

import SwiftUI

struct SettingsWebsiteView: View {
    @EnvironmentObject var webModel: WebViewModel

    @AppStorage("changeUserAgent") var changeUserAgent = false
    @AppStorage("loadLastHistory") var loadLastHistory = false
    @AppStorage("useUrlBar") var useUrlBar = false

    @AppStorage("defaultUrl") var defaultUrl = ""

    @State private var showUrlChangeAlert: Bool = false
    @State private var showUrlBarAlert: Bool = false

    var body: some View {
        // MARK: Website settings (settings that can alter website content)

        Section(header: Text("Sito web")) {
            Toggle(isOn: $changeUserAgent) {
                Text("Richiedi sito \(UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac ? "mobile" : "desktop") ")
            }
            .onChange(of: changeUserAgent) { changed in
                webModel.setUserAgent(changeUserAgent: changed)
                webModel.webView.reload()
            }
        }

        // MARK: Default URL setting

        Section(header: Text("URL di default")) {
            // Auto capitalization modifier will be deprecated at some point
            TextField("https://...", text: $defaultUrl, onEditingChanged: { begin in
                if !begin, UIDevice.current.deviceType != .mac {
                    showUrlChangeAlert.toggle()
                    webModel.loadUrl()
                }
            }, onCommit: {
                if UIDevice.current.deviceType == .mac {
                    showUrlChangeAlert.toggle()
                    webModel.loadUrl()
                }
            })
            .clearButtonMode(.whileEditing)
            .textCase(.lowercase)
            .disableAutocorrection(true)
            .keyboardType(.URL)
            .autocapitalization(.none)
            .alert(isPresented: $showUrlChangeAlert) {
                Alert(
                    title: Text("Modificato URL di default"),
                    message: Text("La pagina si caricherà automaticamente"),
                    dismissButton: .cancel(Text("OK"))
                )
            }
            .disabledAppearance(loadLastHistory)

            Toggle(isOn: $loadLastHistory) {
                Text("Carica URL più recente")
            }
        }

        Section(header: Text("Barra indirizzo")) {
            Toggle(isOn: $useUrlBar) {
                Text("Abilita barra URL")
            }
            .onChange(of: useUrlBar) { changed in
                if changed {
                    showUrlBarAlert.toggle()
                }
            }
            .alert(isPresented: $showUrlBarAlert) {
                Alert(
                    title: Text("Barra URL abilitata"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct SettingsWebsiteView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsWebsiteView()
    }
}
