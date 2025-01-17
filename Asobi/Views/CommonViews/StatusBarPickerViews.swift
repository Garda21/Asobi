//
//  StatusBarBehaviorPicker.swift
//  Asobi
//
//  Created by Brian Dashore on 4/7/22.
//

import SwiftUI

enum StatusBarStyleType: String {
    case theme
    case automatic
    case accent
    case custom
}

struct StatusBarStylePicker: View {
    @AppStorage("statusBarStyleType") var statusBarStyleType: StatusBarStyleType = .custom

    var body: some View {
        List {
            Picker(selection: $statusBarStyleType, label: EmptyView()) {
                Text("Automatic tint")
                    .tag(StatusBarStyleType.automatic)
                Text("Follow theme")
                    .tag(StatusBarStyleType.theme)
                Text("App accent color")
                    .tag(StatusBarStyleType.accent)
                Text("Custom color")
                    .tag(StatusBarStyleType.custom)
            }
        }
        .pickerStyle(.inline)
        .listStyle(.insetGrouped)
        .navigationTitle("Status bar theme")
        .navigationBarTitleDisplayMode(.inline)
    }
}

enum StatusBarBehaviorType: String {
    case hide
    case partialHide
    case pin
}

struct StatusBarBehaviorPicker: View {
    @AppStorage("statusBarPinType") var statusBarPinType: StatusBarBehaviorType = .pin

    var body: some View {
        List {
            Picker(selection: $statusBarPinType, label: EmptyView()) {
                Text("Nascosta")
                    .tag(StatusBarBehaviorType.hide)
                Text("Parzialmente nascosta")
                    .tag(StatusBarBehaviorType.partialHide)
                Text("Fissa")
                    .tag(StatusBarBehaviorType.pin)
            }
        }
        .pickerStyle(.inline)
        .listStyle(.insetGrouped)
        .navigationTitle("Status Bar Behavior")
        .navigationBarTitleDisplayMode(.inline)
    }
}
