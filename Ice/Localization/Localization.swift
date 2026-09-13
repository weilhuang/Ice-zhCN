//
//  Localization.swift
//  Ice
//

import Foundation

/// Helpers for looking up Ice's string catalog in the selected language.
enum Localization {
    /// Returns a localized string from Ice's catalog using the current language.
    static func string(_ value: String.LocalizationValue) -> String {
        String(localized: value, bundle: bundle, locale: locale)
    }

    /// The locale matching the persisted language preference.
    static var locale: Locale {
        AppLanguage.persisted.locale
    }

    /// The `.lproj` bundle for the persisted language, or the main bundle.
    static var bundle: Bundle {
        let language = AppLanguage.persisted
        let resource: String?
        switch language {
        case .system:
            let preferred = Locale.preferredLanguages.first ?? ""
            if preferred.hasPrefix("zh-Hans") || preferred.hasPrefix("zh-CN") || preferred == "zh" {
                resource = "zh-Hans"
            } else if preferred.hasPrefix("zh") {
                // Other Chinese variants fall back to Simplified in this fork.
                resource = "zh-Hans"
            } else {
                return .main
            }
        case .english:
            resource = "en"
        case .simplifiedChinese:
            resource = "zh-Hans"
        }
        if
            let resource,
            let path = Bundle.main.path(forResource: resource, ofType: "lproj"),
            let localizedBundle = Bundle(path: path)
        {
            return localizedBundle
        }
        return .main
    }
}
