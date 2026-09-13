//
//  UpdatesManager.swift
//  Ice
//

import AppKit
import SwiftUI

/// Manager for app updates.
///
/// This Chinese fork does not start Sparkle against upstream Ice. Doing so
/// would replace the localized build with an official English release.
/// Updates are distributed from this repository's GitHub Releases instead.
@MainActor
final class UpdatesManager: NSObject, ObservableObject {
    /// A Boolean value that indicates whether the user can check for updates.
    @Published var canCheckForUpdates = true

    /// The date of the last update check.
    @Published var lastUpdateCheckDate: Date?

    /// The shared app state.
    private(set) weak var appState: AppState?

    /// Automatic update checks are disabled for this fork.
    var automaticallyChecksForUpdates: Bool {
        get { false }
        set { objectWillChange.send() }
    }

    /// Automatic update downloads are disabled for this fork.
    var automaticallyDownloadsUpdates: Bool {
        get { false }
        set { objectWillChange.send() }
    }

    /// GitHub Releases page for this fork.
    static let releasesURL = URL(string: "https://github.com/weilhuang/Ice-zhCN/releases")

    /// Creates an updates manager with the given app state.
    init(appState: AppState) {
        self.appState = appState
        super.init()
    }

    /// Sets up the manager.
    func performSetup() {
        // Sparkle is intentionally not started. See the type comment.
    }

    /// Opens this fork's GitHub Releases page.
    @objc func checkForUpdates() {
        guard let url = Self.releasesURL else {
            return
        }
        appState?.activate(withPolicy: .regular)
        NSWorkspace.shared.open(url)
    }
}

// MARK: UpdatesManager: BindingExposable
extension UpdatesManager: BindingExposable { }
