//
//  RequestApiService.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 20.06.2023.
//

import Foundation
import OSLog

protocol RequestDispatcherProtocol {
    func dispatch(with endpoint: String, requestType: RequestType, parameters: [String: Any], requestBody: Data?) async -> Result<Data, Error>?
}

/// Dispatch API helpers
final class RequestDispatcher: RequestDispatcherProtocol {
    private var logger = Logger(
        subsystem: Bundle.main.identifier,
        category: String(describing: RequestDispatcher.self)
    )
    private(set) var requestBuilder: RequestBuilderProtocol
    
    init(requestBuilder: RequestBuilderProtocol = RequestBuilder()) {
        self.requestBuilder = requestBuilder
    }
    /// Custom URLSession
    var sessionConfig: URLSessionConfiguration {
        let sessionConf = URLSessionConfiguration.default
        sessionConf.timeoutIntervalForRequest = 20.0
        sessionConf.allowsCellularAccess = true
        sessionConf.httpShouldSetCookies = true
        sessionConf.httpShouldUsePipelining = true
        sessionConf.requestCachePolicy = .useProtocolCachePolicy
        sessionConf.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        return sessionConf
    }
    
    /// Dispatches an URLRequest and returns Data from API
    /// - Parameters:
    ///   - endpoint: APIs endpoint
    ///   - requestType: POST, GET
    ///   - parameters: additional http parameters
    ///   - requestBody: body with json
    /// - Returns: Data or Error
    func dispatch(with endpoint: String, requestType: RequestType, parameters: [String: Any], requestBody: Data?) async -> Result<Data, Error>? {
        let newSession = URLSession(configuration: sessionConfig)
        defer {
            newSession.invalidateAndCancel()
        }
        do {
            guard let url = URL(string: endpoint) else {
                throw NetworkError.invalidURL
            }

            guard let urlRequest = requestBuilder.buildRequest(with: url, requestType: requestType, parameters: parameters, requestBody: requestBody) else {
                return nil
            }

            let (data, response) = try await newSession.data(for: urlRequest)

            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.badRequest
            }
            
            if !(200...299).contains(response.statusCode) {
                throw handleHttpError(response.statusCode)
            }
           
            return .success(data)
        } catch {
            self.logger.error("[\(endpoint, privacy: .public)] \(error, privacy: .public)")
            return .failure(error)
        }
    }
    
    /// Returns a decoded NetworkError
    /// - Parameter statusCode: response status code
    /// - Returns: decoded NetworkError
    private func handleHttpError(_ statusCode: Int) -> NetworkError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .error4xx(statusCode)
        case 500: return .serverError
        case 501...599: return .error5xx(statusCode)
        default: return .unknownError
        }
    }
}
