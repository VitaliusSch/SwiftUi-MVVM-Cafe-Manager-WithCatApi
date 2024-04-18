//
//  FileExtension.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 26.12.2022.
//

import Foundation

extension FileManager {
    /// Calculates the document directory
    private var documentDirectory: URL? {
        return self.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    /// Creates URL by a file id
    /// - Parameter fileId: fileId
    /// - Returns: URL by a file id
    func documentDirectoryFile(fileId: String) -> URL? {
        guard let documentDir = FileManager.default.documentDirectory else {return nil}
        return documentDir.appendingPathComponent(addFileExt(fileId: fileId))
    }
    /// Adds the file extension
    /// - Parameters:
    ///   - fileId: fileId
    ///   - ext: file extension
    /// - Returns: file name with extension
    func addFileExt(fileId: String, ext: String = ".jpg") -> String {
        return "\(fileId)\(ext)"
    }
    func copyFileToDocumentDirectory(from sourceURL: URL) -> URL? {
        guard let documentDirectory = documentDirectory else { return nil }
        let fileName = sourceURL.lastPathComponent
        let destinationURL = documentDirectory.appendingPathComponent(fileName)
        if self.fileExists(atPath: destinationURL.path) {
            return destinationURL
        } else {
            do {
                try self.copyItem(at: sourceURL, to: destinationURL)
                return destinationURL
            } catch let error {
                print("Unable to copy file: \(error.localizedDescription)")
            }
        }
        return nil
    }
    /// Removes a file by URL
    /// - Parameter url: file URL
    func removeFileFromDocumentDirectory(url: URL) {
        guard let documentDirectory = documentDirectory else { return }
        let fileName = url.lastPathComponent
        let fileUrl = documentDirectory.appendingPathComponent(fileName)
        if self.fileExists(atPath: fileUrl.path) {
            do {
                try self.removeItem(at: url)
            } catch let error {
                print("Unable to remove file: \(error.localizedDescription)")
            }
        }
    }
    /// Gets the directory contents
    /// - Parameter url: URL directory
    /// - Returns: directory contents array
    func getContentsOfDirectory(_ url: URL) -> [URL] {
        var isDirectory: ObjCBool = false

        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory), isDirectory.boolValue else { return [] }
        do {
            return try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
        } catch let error {
            print("Unable to get directory contents: \(error.localizedDescription)")
        }
        return []
    }
}
