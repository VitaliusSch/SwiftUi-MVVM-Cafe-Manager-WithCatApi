//
//  Networking.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 02.03.2023.
//

import Foundation

enum RequestType: String {
    case requestPost = "POST"
    case requestGet = "GET"
    case requestPut = "PUT"
    case requestDelete = "DELETE"
}

protocol NetworkingProtocol {
    func get<T: Codable>(parameters: [String: Any]) async -> Result<[T], Error>
    func getData(url: URL) async -> Result<Data, Error>
}
