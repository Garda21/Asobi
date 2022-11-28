//
//  SettingsAppearanceView.swift
//  Asobi
//
//  Created by Brian Dashore on 4/9/22.
//

import SwiftUI

struct SettingsAppearanceView: View {
    @EnvironmentObject var webModel: WebViewModel

    @AppStorage("leftHandMode") var leftHandMode = false
    @AppStorage("useDarkTheme") var useDarkTheme = false

    @AppStorage("followSystemTheme") var followSystemTheme = true

    @AppStorage("navigationAccent") var navigationAccent: Color = .red
    @AppStorage("statusBarStyleType") var statusBarStyleType: StatusBarStyleType = .custom
    @AppStorage("statusBarAccent") var statusBarAccent: Color = .clear

    var body: some View {
        // MARK: Appearance settings

        // The combination of toggles and a ColorPicker cause keyboard shortcuts to stop working
        // Reported this bug to Apple
        Section(header: Text("Aspetto")) {
            Toggle(isOn: $leftHandMode) {
                Text("Modalità mano sinistra")
            }

            Toggle(isOn: $useDarkTheme) {
                Text("Usare tema scuro")
            }
            .disabledAppearance(followSystemTheme)

            Toggle(isOn: $followSystemTheme) {
                Text("Usare tema di sistema")
            }

            ColorPicker("Colore in evidenza", selection: $navigationAccent, supportsOpacity: false)
                .onChange(of: navigationAccent) { _ in
                    if statusBarStyleType == .accent {
                        webModel.setStatusbarColor()
                    }
                }

            if UIDevice.current.deviceType != .mac {
                NavigationLink(
                    destination: StatusBarStylePicker(),
                    label: {
                        HStack {
                            Text("Stile della barra di sistema")
                            Spacer()
                            Group {
                                switch statusBarStyleType {
                                case .automatic:
                                    Text("Automatico")
                                case .theme:
                                    Text("Tema")
                                case .accent:
                                    Text("Evidenziato")
                                case .custom:
                                    Text("Personalizzato")
                                }
                            }
                            .foregroundColor(.gray)
                        }
                    }
                )
                .onChange(of: statusBarStyleType) { _ in
                    webModel.setStatusbarColor()
                }

                ColorPicker("Colore della barra di sistema", selection: $statusBarAccent, supportsOpacity: true)
                    .onChange(of: statusBarAccent) { _ in
                        webModel.setStatusbarColor()
                    }
                    .disabledAppearance(statusBarStyleType != .custom)
            }
        }
    }
}

struct SettingsAppearanceView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsAppearanceView()
    }
}
