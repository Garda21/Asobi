//
//  NavigationBarView.swift
//  Asobi
//
//  Created by Brian Dashore on 8/4/21.
//

import SwiftUI

struct NavigationBarView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @AppStorage("leftHandMode") var leftHandMode = false
    @AppStorage("navigationAccent") var navigationAccent: Color = .red

    var body: some View {
        VStack {
            // Sets button position depending on hand mode setting
            HStack {
                if leftHandMode {
                    ForwardBackButtonView()
                    Spacer()
                    SettingsButtonView()
                    Spacer()
                    LibraryButtonView()
                    Spacer()
                    if UIDevice.current.deviceType != .phone {
                        RefreshButtonView()
                        Spacer()
                        FindInPageButtonView()
                        Spacer()
                    }
                    HomeButtonView()
                } else {
                    HomeButtonView()
                    Spacer()
                    if UIDevice.current.deviceType != .phone {
                        RefreshButtonView()
                        Spacer()
                        FindInPageButtonView()
                        Spacer()
                    }
                    LibraryButtonView()
                    Spacer()
                    SettingsButtonView()
                    Spacer()
                    ForwardBackButtonView()
                }
            }
            .padding()
            .accentColor(navigationAccent)

            if UIDevice.current.deviceType == .phone && UIDevice.current.hasNotch {
                Spacer()
                    .frame(height: 20)
            }
        }
        .background(colorScheme == .light ? .white : .black)
        .frame(maxWidth: UIDevice.current.deviceType == .phone ? .infinity : 600)
        .cornerRadius(UIDevice.current.deviceType == .phone ? 0 : 10)
    }
}

struct NavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBarView()
    }
}
