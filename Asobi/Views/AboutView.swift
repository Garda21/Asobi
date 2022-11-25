//
//  AboutView.swift
//  Asobi
//
//  Created by Brian Dashore on 8/5/21.
//

import SwiftUI

struct AboutView: View {
    @AppStorage("selectedIconKey") var selectedIconKey = "AppImage"

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Image(selectedIconKey)
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(25)

            Text("taac - il sistema operativo per la ristorazione indipendente")
                .padding()

            List {
                ListRowTextView(leftText: "L'applicazione taac POS si basa su Asobi un programma gratuito e open source sviluppato da Brian Dashore con licenza Apache-2.0.")
                ListRowExternalLinkView(text: "Sito web di Brian Dashore", link: "https://kingbri.dev/asobi")
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Informazioni")
    }
}

#if DEBUG
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
#endif
