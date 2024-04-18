//
//  LogFileManager.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 08.11.2023.
//

import Foundation

protocol LogFileManagerProtocol {
    func existsFile() -> Bool
    func addLog(logData: String)
    func queryLogFiles() -> [URL]
    func removeFile(url: URL)
    func readFile(url: URL) -> String
}

/// Log file manager
struct LogFileManager: LogFileManagerProtocol {
    private let fileManager = FileManager.default
    private var logDirectory: URL = FileManager.default.temporaryDirectory
    private var fileId: String {
        return "\(Date().toString(dateFormat: AppConstants.Date.FormatLogDate)).log"
    }
    init() {
        do {
            let baseURL = try fileManager.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            logDirectory = baseURL.appendingPathComponent("simon-log", isDirectory: true)
            try fileManager.createDirectory(at: logDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error)
        }
    }
    /// Checks log file
    /// - Returns: is file exists?
    func existsFile() -> Bool {
        if !fileManager.fileExists(atPath: logDirectory.appendingPathComponent(fileId).path) {
            if !fileManager.createFile(atPath: logDirectory.appendingPathComponent(fileId).path, contents: nil, attributes: nil) {
                return false
            }
        }
        return true
    }
    /// Creates new log file
    /// - Parameters:
    ///   - path: log file path
    func addLog(logData: String) {
        let handle = FileHandle(forWritingAtPath: logDirectory.appendingPathComponent(fileId).path)
        handle?.seekToEndOfFile()
        handle?.write((logData + ",").data(using: String.Encoding.utf8)!)
        handle?.closeFile()
    }
    /// Gets log files
    /// - Returns: array of log files
    func queryLogFiles() -> [URL] {
        return fileManager.getContentsOfDirectory(logDirectory)
    }
    /// Removes log file
    /// - Parameter url: URL file to remove
    func removeFile(url: URL) {
        try? fileManager.removeItem(at: url)
    }
    /// Reads log file
    /// - Parameter url: URL of log file to read
    /// - Returns: readed cotnent
    func readFile(url: URL) -> String {
        let data = try? Data(contentsOf: url)
        return String(data: data ?? Data(count: 0), encoding: .utf8) ?? ""
    }
}
