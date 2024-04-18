//
//  Networking.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 02.03.2023.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case badRequestName
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case error4xx(_ code: Int)
    case serverError
    case error5xx(_ code: Int)
    case decodingError( _ description: String)
    case urlSessionFailed(_ error: URLError)
    case timeOut
    case unknownError
    case invalidURL
    case someError( _ description: String)
}

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
