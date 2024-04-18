//
//  RequestDispatcher.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 20.06.2023.
//

import Foundation

protocol RequestBuilderProtocol {
    func buildRequest(with url: URL, requestType: RequestType, parameters: [String: Any], requestBody: Data?) -> URLRequest?
}

/// Build requests helpers
final class RequestBuilder: RequestBuilderProtocol {
    /// Transform an url and parameters into a standard URL request
    /// - Parameters:
    ///   - url: APIs urlz
    ///   - requestType: POST GET
    ///   - parameters: additional http parameters
    ///   - requestBody: body with json
    /// - Returns: builded URLRequest
    func buildRequest(with url: URL, requestType: RequestType, parameters: [String: Any], requestBody: Data?) -> URLRequest? {
        switch requestType {
        case .requestGet:
            return createGetRequestWithURLComponents(url: url, parameters: parameters, requestBody: requestBody, requestType: requestType)
        case .requestPost, .requestPut, .requestDelete:
            return createPostRequestWithBody(url: url, parameters: parameters, requestBody: requestBody, requestType: requestType)
        }
    }
    
    /// Builds GET- request
    /// - Parameters:
    ///   - url: APIs url
    ///   - parameters: additional http parameters
    ///   - requestType: POST GET
    /// - Returns: URLRequest
    private func createGetRequestWithURLComponents(url: URL, parameters: [String: Any], requestBody: Data?, requestType: RequestType) -> URLRequest? {
        var components = URLComponents(string: url.absoluteString)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: "\(value)")
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        var request = URLRequest(url: components.url ?? url)
        request.httpMethod = requestType.rawValue
        
        return request
    }
    
    /// Builds POST-request
    /// - Parameters:
    ///   - url: APIs url
    ///   - parameters: additional http parameters
    ///   - requestBody: body with json
    ///   - requestType: POST GET
    /// - Returns: URLRequest
    private func createPostRequestWithBody(url: URL, parameters: [String: Any], requestBody: Data?, requestType: RequestType) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.addValue(AppConstants.AccessKey.AccessKey, forHTTPHeaderField: AppConstants.AccessKey.AccessKeyParameterCaption)
        
        request.httpBody = requestBody
        request.httpMethod = requestType.rawValue
        return request
    }
}
