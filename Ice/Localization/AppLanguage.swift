//
//  AppLanguage.swift
//  Ice
//

import Foundation
import SwiftUI

/// Languages the user can select for Ice's interface.
enum AppLanguage: String, CaseIterable, Identifiable {
    /// Follow the macOS preferred language list.
    case system
    /// English (the source locale).
    case english
    /// Simplified Chinese.
    case simplifiedChinese

    var id: String { rawValue }

    /// The Apple locale identifier used to load translations, or `nil` when
    /// following the system language.
    var localeIdentifier: String? {
        switch self {
        case .system:
            nil
        case .english:
            "en"
        case .simplifiedChinese:
            "zh-Hans"
        }
    }

    /// Title shown in the language picker.
    ///
    /// Language names stay in their native form so they remain recognizable
    /// regardless of the current interface language.
    var menuTitle: LocalizedStringKey {
        switch self {
        case .system:
            "Follow System"
        case .english:
            "English"
        case .simplifiedChinese:
            "简体中文"
        }
    }

    /// The locale used by SwiftUI and `String(localized:)`.
    var locale: Locale {
        if let localeIdentifier {
            Locale(identifier: localeIdentifier)
        } else {
            .autoupdatingCurrent
        }
    }

    /// Writes `AppleLanguages` so AppKit and Foundation pick up the choice.
    func applyAppleLanguages() {
        if let localeIdentifier {
            UserDefaults.standard.set([localeIdentifier], forKey: "AppleLanguages")
        } else {
            UserDefaults.standard.removeObject(forKey: "AppleLanguages")
        }
    }
}
