//
//  URLRequestExtension.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 26.12.2022.
//

import Foundation

extension URLRequest {
    mutating func setMultipartFormDataBody(params: [String: (Data, filename: String?)]) {
        let boundary = "---\(UUID().uuidString)"
        self.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var body = Data()
        for (key, (data, filename)) in params {
            if let filename = filename {
                body.addFileMultiPart(boundary: boundary, name: "file", filename: filename, contentType: "image/png", data: data)
            } else {
                body.addMultiPart(boundary: boundary, name: key, contentType: "", data: data)
            }
        }
        body.addMultiPartEnd(boundary: boundary)
        self.httpBody = body
    }
}
