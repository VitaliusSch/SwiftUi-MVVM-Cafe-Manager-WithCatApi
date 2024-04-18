//
//  LogModel.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 08.11.2023.
//

import Foundation

/// Log Model
struct LogsModel: BasicModel {
    var id: String = UUID().uuidString.lowercased()
    var level: String!
    var deviceId: String!
    var deviceModel: String!
    var deviceOsVersion: String!
    var appVersion: String!
    var message: String!
    var created: String!
}

extension LogsModel {
    /// Makes a log string
    var logString: String {
        return "[\(created ?? ""))] \(message ?? "")"
    }
}
