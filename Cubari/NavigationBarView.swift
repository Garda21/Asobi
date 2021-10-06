//
//  NavigationBarView.swift
//  Cubari
//
//  Created by Brian Dashore on 8/4/21.
//

import SwiftUI

struct NavigationBarView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @AppStorage("leftHandMode") var leftHandMode = false
    @AppStorage("navigationAccent") var navigationAccent: Color = .red
    @State private var showAbout = false
    
    var body: some View {
        VStack {
            Spacer()

            // Sets button position depending on hand mode setting
            HStack {
                if leftHandMode {
                    if horizontalSizeClass == .regular {
                        Spacer()
                    }
                    ForwardBackButtonView()
                    Spacer()
                    SettingsButtonView()
                    Spacer()
                    HomeButtonView()
                    Spacer()
                    AboutButtonView()
                    if horizontalSizeClass == .regular {
                        Spacer()
                    }
                } else {
                    if horizontalSizeClass == .regular {
                        Spacer()
                    }
                    AboutButtonView()
                    Spacer()
                    HomeButtonView()
                    Spacer()
                    SettingsButtonView()
                    Spacer()
                    ForwardBackButtonView()
                    if horizontalSizeClass == .regular {
                        Spacer()
                    }
                }
            }
            .padding()
            .background(Color.black)
            .accentColor(navigationAccent)
        }
        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
    }
}

#if DEBUG
struct NavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBarView()
    }
}
#endif
