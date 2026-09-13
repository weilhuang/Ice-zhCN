//
//  IceApp.swift
//  Ice
//

import SwiftUI

@main
struct IceApp: App {
    @NSApplicationDelegateAdaptor var appDelegate: AppDelegate
    @ObservedObject var appState = AppState()
    @ObservedObject private var languageManager = LanguageManager.shared

    init() {
        LanguageManager.applyPreferredLanguageAtLaunch()
        NSSplitViewItem.swizzle()
        MigrationManager.migrateAll(appState: appState)
        appDelegate.assignAppState(appState)
    }

    var body: some Scene {
        SettingsWindow(appState: appState)
            .environment(\.locale, languageManager.locale)
        PermissionsWindow(appState: appState)
            .environment(\.locale, languageManager.locale)
    }
}
