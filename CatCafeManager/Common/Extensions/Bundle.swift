//
//  BundleExtension.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 27.02.2023.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    var buildVersionNumber: String {
        infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
    var identifier: String {
        infoDictionary?["CFBundleIdentifier"] as? String ?? ""
    }
}
