//
//  LanguageManager.swift
//  Ice
//

import AppKit
import SwiftUI

/// Persists the user's language choice and applies it to Ice.
@MainActor
final class LanguageManager: ObservableObject {
    /// Shared manager used by settings and hosted SwiftUI panels.
    static let shared = LanguageManager()

    /// The language selected in Settings.
    @Published var language: AppLanguage {
        didSet {
            guard oldValue != language else {
                return
            }
            Defaults.set(language.rawValue, forKey: .iceAppLanguage)
            language.applyAppleLanguages()
            needsRelaunch = true
        }
    }

    /// When `true`, Settings should prompt the user to restart Ice.
    @Published var needsRelaunch = false

    /// Locale matching the current selection (used as a SwiftUI environment value).
    var locale: Locale { language.locale }

    private init() {
        let raw = Defaults.string(forKey: .iceAppLanguage)
        self.language = AppLanguage(rawValue: raw ?? "") ?? .system
        language.applyAppleLanguages()
    }

    /// Applies the saved language before any windows or menus are created.
    static func applyPreferredLanguageAtLaunch() {
        AppLanguage.persisted.applyAppleLanguages()
    }

    /// Relaunches Ice so AppKit menus and hosted panels pick up the new catalog.
    func relaunch() {
        needsRelaunch = false
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.createsNewApplicationInstance = true
        NSWorkspace.shared.openApplication(
            at: Bundle.main.bundleURL,
            configuration: configuration
        ) { _, _ in
            DispatchQueue.main.async {
                NSApp.terminate(nil)
            }
        }
    }
}

extension LanguageManager: BindingExposable { }

extension AppLanguage {
    /// The language stored in UserDefaults, defaulting to ``system``.
    static var persisted: AppLanguage {
        let raw = Defaults.string(forKey: .iceAppLanguage)
        return AppLanguage(rawValue: raw ?? "") ?? .system
    }
}

extension View {
    /// Applies Ice's selected locale so SwiftUI strings update with the picker.
    func iceLocalized() -> some View {
        modifier(IceLocalizationModifier())
    }
}

private struct IceLocalizationModifier: ViewModifier {
    @ObservedObject private var languageManager = LanguageManager.shared

    func body(content: Content) -> some View {
        content
            .environment(\.locale, languageManager.locale)
            .environmentObject(languageManager)
            .id(languageManager.language)
    }
}
