//
//  DataExtension.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 26.12.2022.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        self.append(string.data(using: .utf8)!)
    }
    /// Creates multipart with body
    /// - Parameters:
    ///   - boundary: boundary id string
    ///   - name: name of part
    ///   - filename: filen ame
    ///   - contentType: content type
    ///   - data: binary file
    mutating func addFileMultiPart(boundary: String, name: String, filename: String, contentType: String, data: Data) {
        print("adding boundary: \(boundary), name: \(name), filename: \(filename), contentType: \(contentType) data length: \(data.count) ")
        self.append("\r\n--\(boundary)\r\n")
        self.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n")
        self.append("Content-Type: \(contentType)\r\n\r\n")
        self.append(data)
    }
    mutating func addMultiPart(boundary: String, name: String, contentType: String, data: Data) {
        print("adding boundary: \(boundary), name: \(name), data: \(data) ")
        self.append("\r\n--\(boundary)\r\n")
        self.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
        self.append(data)
    }
    mutating func addMultiPartEnd(boundary: String) {
        self.append("\r\n--\(boundary)--")
    }
}
