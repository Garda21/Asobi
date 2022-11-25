//
//  SettingsPrivacyView.swift
//  Asobi
//
//  Created by Brian Dashore on 4/9/22.
//

import LocalAuthentication
import SwiftUI

struct SettingsPrivacyView: View {
    @EnvironmentObject var webModel: WebViewModel
    @EnvironmentObject var navModel: NavigationViewModel

    @AppStorage("incognitoMode") var incognitoMode = false
    @AppStorage("blockAds") var blockAds = false
    @AppStorage("blockPopups") var blockPopups = false
    @AppStorage("blurInRecents") var blurInRecents = false
    @AppStorage("forceSecurityCredentials") var forceSecurityCredentials = false

    @AppStorage("httpsOnlyMode") var httpsOnlyMode = true

    @State private var showAdblockAlert: Bool = false
    @State private var alreadyAuthenticated: Bool = false
    @State private var presentAlert: Bool = false

    var body: some View {
        // MARK: Privacy settings

        Section(header: Text("Privacy e sicurezza"))
                 {
            Toggle(isOn: $incognitoMode) {
                Text("Modalità privata")
            }

            Toggle(isOn: $httpsOnlyMode) {
                Text("Consenti solo HTTPS")
            }

            Toggle(isOn: $blockAds) {
                Text("Blocca pubblicità")
            }
            .onChange(of: blockAds) { changed in
                if changed {
                    Task {
                        await webModel.enableBlocker()
                    }
                } else {
                    webModel.disableBlocker()
                }

                showAdblockAlert.toggle()
            }
            .alert(isPresented: $showAdblockAlert) {
                Alert(
                    title: Text(blockAds ? "Adblock attivo" : "Adblock disattivo"),
                    message: Text("La pagina si ricaricherà alla chiusura di questa finestra"),
                    dismissButton: .cancel(Text("OK"))
                )
            }

            Toggle(isOn: $blockPopups) {
                Text("Blocca popups")
            }

            if blockPopups {
                NavigationLink("Ecccezioni popup", destination: PopupExceptionView())
            }

            if UIDevice.current.deviceType != .mac {
                Toggle(isOn: $blurInRecents) {
                    Text("Blur nei menu recenti")
                }
            }

            if navModel.authenticationPresent() {
                Toggle(isOn: $forceSecurityCredentials) {
                    Text("Richiedi autenticazione")
                }
                .onChange(of: forceSecurityCredentials) { changed in
                    // To prevent looping of authentication prompts
                    if alreadyAuthenticated {
                        alreadyAuthenticated = false
                        return
                    }

                    let context = LAContext()

                    Task {
                        do {
                            let result = try await context.evaluatePolicy(
                                .deviceOwnerAuthentication,
                                localizedReason: "Bisogna autenticarsi per cambiare questo parametro"
                            )

                            forceSecurityCredentials = result ? changed : !changed
                        } catch {
                            // Ignore and log the error
                            debugPrint("Errore autenticazione: \(error)")

                            await MainActor.run {
                                alreadyAuthenticated = true

                                forceSecurityCredentials = !changed
                            }
                        }
                    }
                }
            }
        }
    }
}

struct SettingsPrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPrivacyView()
    }
}
