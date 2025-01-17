//
//  RefreshButtonView.swift
//  Asobi
//
//  Created by Brian Dashore on 10/6/21.
//

import SwiftUI

struct RefreshButtonView: View {
    @EnvironmentObject var webModel: WebViewModel

    var body: some View {
        Button(action: {
            webModel.webView.reload()
            webModel.showLoadingProgress = false
        }, label: {
            Image(systemName: "arrow.clockwise")
                .padding(.horizontal, 4)
        })
        .keyboardShortcut("r")
    }
}

struct RefreshButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RefreshButtonView()
    }
}
