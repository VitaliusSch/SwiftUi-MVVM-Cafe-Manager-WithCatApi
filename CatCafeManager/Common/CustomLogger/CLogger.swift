//
//  CustomLogger.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 08.11.2023.
//

import Foundation
import UIKit

/// A custom static logger class
/// Use CLogger.LogE to create log fie
/// Use CLogger.getAllLogs to show all logs
final class CLogger {
    static var shared = CLogger()
    private let logFile: LogFileManagerProtocol = LogFileManager()
    private let queque = DispatchQueue(label: "\(Bundle.main.identifier).logger")
    private let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
    private let device = UIDevice.current.model
    private let osVersion = UIDevice.current.systemVersion
    /// Common log function
    /// - Parameters:
    ///   - logMessage: log message
    ///   - logType: logType description
    ///   - file: file in project
    ///   - line: line in file project
    private func log(logMessage: String = "",
                     logLevel: EnumLogLevel,
                     file: String = #file,
                     line: Int = #line
    ) {
        let currentLog = LogsModel(
            id: UUID().uuidString.lowercased(),
            level: "\(logLevel)",
            deviceId: deviceId,
            deviceModel: device,
            deviceOsVersion: osVersion,
            appVersion: Bundle.main.releaseVersionNumber,
            message: "in file:\(file) on line:\(line) " + logMessage,
            created: "\(Date().toString(dateFormat: AppConstants.Date.FormatLocalDate))"
        )
        do {
            let logData = try JSONEncoder().encode(currentLog)
            queque.sync {
                if logFile.existsFile() {
                    logFile.addLog(logData: String(data: logData, encoding: .utf8) ?? "")
                }
            }
        } catch {
            print(error)
        }
    }
    /// Возвращает содержимое лог-файла
    /// - Returns: содержимое лог-файла
    func getFirstLog() -> String {
        let files = logFile.queryLogFiles()
        guard !files.isEmpty else {
            return ""
        }
        let firstLogName = files[0]
        var logData = ""
        queque.sync {
            logData = logFile.readFile(url: firstLogName)
            logFile.removeFile(url: firstLogName)
        }
        return logData
    }
    /// Возвращает содержимое всех логов
    /// - Returns: массив логов
    func getAllLogs() -> [String] {
        let files = logFile.queryLogFiles()
        guard !files.isEmpty else {
            return []
        }
        var logArray = [String]()
        queque.sync {
            for eachFile in files {
                let logData = logFile.readFile(url: eachFile)
                logArray.append(logData)
            }
        }
        return logArray
    }

    /// Логирование дебажных сообщений
    /// - Parameters:
    ///   - tag: тэг - главый модуль
    ///   - processName: имя процесса
    ///   - procName: имя процедуры
    ///   - paramIn: входные параметры
    ///   - paramOut: выходные параметры или ошибка
    static func logD(
        logMessage: String = "",
        file: String = #file,
        line: Int = #line
    ) {
        shared.log(
            logMessage: logMessage,
            logLevel: .DEBUG,
            file: file,
            line: line
        )
    }
    /// Логирование ошибок
    /// - Parameters:
    ///   - tag: тэг - главый модуль
    ///   - processName: имя процесса
    ///   - procName: имя процедуры
    ///   - paramIn: входные параметры
    ///   - paramOut: выходные параметры или ошибка
    static func logE(
        logMessage: String = "",
        file: String = #file,
        line: Int = #line
    ) {
        shared.log(
            logMessage: logMessage,
            logLevel: .ERROR,
            file: file,
            line: line
        )
    }
    /// Логирование предупреждений
    /// - Parameters:
    ///   - tag: тэг - главый модуль
    ///   - processName: имя процесса
    ///   - procName: имя процедуры
    ///   - paramIn: входные параметры
    ///   - paramOut: выходные параметры или ошибка
    static func logW(
        logMessage: String = "",
        file: String = #file,
        line: Int = #line
    ) {
        shared.log(
            logMessage: logMessage,
            logLevel: .WARNING,
            file: file,
            line: line
        )
    }
    /// Логирование информационное
    /// - Parameters:
    ///   - tag: тэг - главый модуль
    ///   - processName: имя процесса
    ///   - procName: имя процедуры
    ///   - paramIn: входные параметры
    ///   - paramOut: выходные параметры или ошибка
    static func logI(
        logMessage: String = "",
        file: String = #file,
        line: Int = #line
    ) {
        shared.log(
            logMessage: logMessage,
            logLevel: .INFO,
            file: file,
            line: line
        )
    }
}
