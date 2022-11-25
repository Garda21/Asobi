//
//  SettingsBehaviorView.swift
//  Asobi
//
//  Created by Brian Dashore on 4/9/22.
//

import SwiftUI

struct SettingsBehaviorView: View {
    @EnvironmentObject var webModel: WebViewModel
    @EnvironmentObject var navModel: NavigationViewModel

    @AppStorage("persistNavigation") var persistNavigation = false
    @AppStorage("autoHideNavigation") var autoHideNavigation = false
    @AppStorage("grayHomeIndicator") var grayHomeIndicator = false
    @AppStorage("showBottomInset") var showBottomInset = false
    @AppStorage("forceFullScreen") var forceFullScreen = false
    @AppStorage("clearCacheAtStart") var clearCacheAtStart = false
    @AppStorage("useStatefulBookmarks") var useStatefulBookmarks = false

    @AppStorage("allowSwipeNavGestures") var allowSwipeNavGestures = true

    @AppStorage("statusBarPinType") var statusBarPinType: StatusBarBehaviorType = .partialHide

    @State private var showForceFullScreenAlert: Bool = false

    var body: some View {
        // MARK: Browser behavior settings

        Section(header: Text("Comportamento"),
                footer: VStack(alignment: .leading, spacing: 8) {
                }) {
            Toggle(isOn: $persistNavigation) {
                Text("Bloccare barra di navigazione")
            }
            .onChange(of: persistNavigation) { changed in
                if changed {
                    autoHideNavigation = false
                }

                navModel.setNavigationBar(true)
            }

            Toggle(isOn: $autoHideNavigation) {
                Text("Nascondere automaticamente la barra di navigazione")
            }
            .onChange(of: autoHideNavigation) { changed in
                // Immediately hide the navbar to force autohide functionality
                if changed {
                    navModel.setNavigationBar(false)
                }
            }
            .disabledAppearance(persistNavigation)
            .disabled(persistNavigation)

            if UIDevice.current.hasNotch, UIDevice.current.deviceType != .mac {
                Toggle(isOn: $grayHomeIndicator) {
                    Text("Nascondere indicatore home")
                }

                Toggle(isOn: $showBottomInset) {
                    Text("Mostra il riquadro inferiore")
                }
            }

            if UIDevice.current.deviceType != .mac {
                NavigationLink(
                    destination: StatusBarBehaviorPicker(),
                    label: {
                        HStack {
                            Text("Comportamento della barra di stato")
                            Spacer()
                            Group {
                                switch statusBarPinType {
                                case .hide:
                                    Text("Nascosta")
                                case .partialHide:
                                    Text("Parzialmente nascosta")
                                case .pin:
                                    Text("Fissa")
                                }
                            }
                            .foregroundColor(.gray)
                        }
                    }
                )
                .onChange(of: statusBarPinType) { _ in
                    webModel.setStatusbarColor()
                }
            }

            Toggle(isOn: $forceFullScreen) {
                Text("Video a schermo intero")
            }
            .onChange(of: forceFullScreen) { _ in
                showForceFullScreenAlert.toggle()
            }
            .alert(isPresented: $showForceFullScreenAlert) {
                Alert(
                    title: Text(forceFullScreen ? "Schermo intero attivo" : "Schermo intero disattivo"),
                    message: Text("Bisogna riavviare l'app per cambiare questa impostazione"),
                    dismissButton: .cancel(Text("OK"))
                )
            }

            Toggle(isOn: $clearCacheAtStart) {
                Text("Cancellare cache all'avvio")
            }

            Toggle(isOn: $allowSwipeNavGestures) {
                Text("Abilitare gestures da browser")
            }
            .onChange(of: allowSwipeNavGestures) { changed in
                if changed {
                    webModel.webView.allowsBackForwardNavigationGestures = true
                } else {
                    webModel.webView.allowsBackForwardNavigationGestures = false
                }
            }

        }
    }
}

struct SettingsBehaviorView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsBehaviorView()
    }
}
