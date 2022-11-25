//
//  ContentView.swift
//  Asobi
//
//  Created by Brian Dashore on 8/2/21.
//

import SwiftUI
import SwiftUIX
import UniformTypeIdentifiers

struct ContentView: View {
    @EnvironmentObject var webModel: WebViewModel
    @EnvironmentObject var navModel: NavigationViewModel
    @EnvironmentObject var downloadManager: DownloadManager

    @AppStorage("autoHideNavigation") var autoHideNavigation = false
    @AppStorage("persistNavigation") var persistNavigation = false
    @AppStorage("useDarkTheme") var useDarkTheme = false
    @AppStorage("followSystemTheme") var followSystemTheme = true
    @AppStorage("navigationAccent") var navigationAccent: Color = .red
    @AppStorage("statusBarPinType") var statusBarPinType: StatusBarBehaviorType = .partialHide
    @AppStorage("showBottomInset") var showBottomInset = false

    @State private var isKeyboardPresented = false

    var body: some View {
        ZStack {
            // Background color for orientation changes
            Rectangle()
                .foregroundColor(statusBarPinType == .hide ? .clear : webModel.backgroundColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture(count: autoHideNavigation ? 1 : 3) {
                    navModel.toggleNavigationBar()
                }
                .ignoresSafeArea()
                .zIndex(0)

            // WebView
            WebView()
                .alert(item: $downloadManager.downloadTypeAlert) { alert in
                    switch alert {
                    case .http:
                        return Alert(
                            title: Text("Scaricare il file?"),
                            message: Text("Vuoi iniziare il download del file?"),
                            primaryButton: .default(Text("Inizia")) {
                                if let downloadUrl = downloadManager.downloadUrl {
                                    Task {
                                        await downloadManager.httpDownloadFrom(url: downloadUrl)
                                    }
                                } else {
                                    webModel.toastDescription = "Impossibile scaricare da questo URL"
                                }
                            },
                            secondaryButton: .cancel {
                                downloadManager.downloadUrl = nil
                            }
                        )
                    case .blob:
                        return Alert(
                            title: Text("Salvere il file?"),
                            message: Text("Vuoi salvare il file appena scaricato?"),
                            primaryButton: .default(Text("Salva")) {
                                downloadManager.completeBlobDownload()
                            },
                            secondaryButton: .destructive(Text("Elimina")) {
                                downloadManager.deleteBlobDownload()
                            }
                        )
                    }
                }
                .fileImporter(isPresented: $downloadManager.showDefaultDirectoryPicker, allowedContentTypes: [UTType.folder]) { result in
                    switch result {
                    case let .success(path):
                        downloadManager.setDefaultDownloadDirectory(downloadPath: path)
                    case let .failure(error):
                        webModel.toastDescription = error.localizedDescription
                    }

                    navModel.currentSheet = .settings
                }
                .edgesIgnoringSafeArea(statusBarPinType == .hide ? (showBottomInset ? .top : .vertical) : (showBottomInset ? [] : .bottom))
                .zIndex(1)

            // ProgressView for loading
            if webModel.showLoadingProgress {
                GroupBox {
                    VStack {
                        ZStack {
                            Text("\(String(format: "%.0f", round(webModel.webView.estimatedProgress * 100)))%")

                            CircularProgressBar(webModel.webView.estimatedProgress)
                                .lineWidth(6)
                                .foregroundColor(navigationAccent)
                                .frame(width: 60, height: 60)
                        }

                        Text("Caricamento...")
                            .font(.title2)
                    }
                }
                .zIndex(2)
            }

            // Error view, download bar, and find in page bar
            VStack {
                Spacer()

                // Error description view
                if webModel.showToast {
                    VStack {
                        GroupBox {
                            switch webModel.toastType {
                            case .info:
                                Text(webModel.toastDescription ?? "Si è verificato un errore inaspettato... contattare supporto@gotaac.it")
                            case .error:
                                Text("Error: \(webModel.toastDescription ?? "Si è verificato un errore inaspettato... contattare supporto@gotaac.it")")
                            }
                        }
                    }
                    .transition(AnyTransition.move(edge: .bottom))
                    .animation(.easeInOut(duration: 0.3))
                    .padding()
                }

                // Calls the find in page view
                if webModel.showFindInPage {
                    FindInPageView()
                }

                if webModel.showUrlBar {
                    UrlBarView()
                }

                // Download progress bar view
                if downloadManager.showDownloadProgress {
                    VStack {
                        GroupBox {
                            Text("Download in corso...")
                            HStack {
                                ProgressView(value: downloadManager.downloadProgress, total: 1.00)
                                    .progressViewStyle(LinearProgressViewStyle(tint: navigationAccent))

                                Button("Annulla") {
                                    downloadManager.currentDownload?.cancel()
                                    downloadManager.currentDownload = nil
                                    downloadManager.showDownloadProgress = false
                                }
                            }
                        }
                    }
                    .transition(AnyTransition.move(edge: .bottom))
                    .animation(.easeInOut(duration: 0.3))
                    .padding()
                }

                // Fills up navigation bar height
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(height: isKeyboardPresented ? 0 : (navModel.showNavigationBar ? 50 : 0))
            }
            .zIndex(3)

            // Navigation Bar
            VStack {
                Spacer()

                if navModel.showNavigationBar {
                    NavigationBarView()
                        .onAppear {
                            if autoHideNavigation {
                                navModel.autoHideNavigationBar()
                            }
                        }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .zIndex(4)
        }
        .onReceive(keyboardPublisher) { value in
            isKeyboardPresented = value
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
#endif
