//
//  NetworkError.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 28.05.2024.
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
