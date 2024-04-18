//
//  BasicService.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 20.06.2023.
//

import Foundation

/// Basic class for working with API
open class Service: NetworkingProtocol {
    private(set) var route: String
    private(set) var requestDispatcher: RequestDispatcherProtocol
    /// Сервис для отправки запросов к uws
    private(set) var requestbuilder: RequestBuilderProtocol
    
    init(route: String, requestbuilder: RequestBuilderProtocol = RequestBuilder(), requestDispatcher: RequestDispatcherProtocol?) {
        self.route = route
        self.requestbuilder = requestbuilder
        if requestDispatcher == nil {
            self.requestDispatcher = RequestDispatcher(requestBuilder: requestbuilder)
        } else {
            self.requestDispatcher = requestDispatcher!
        }
    }
    
    func get<T: Codable>(parameters: [String: Any]) async -> Result<[T], Error> {
        guard let result = await requestDispatcher.dispatch(with: route, requestType: RequestType.requestGet, parameters: parameters, requestBody: nil) else {
            return .failure(NetworkError.badRequest)
        }
        
        do {
            switch result {
            case .success(let data):
                let rows = try JSONDecoder().decode([T].self, from: data)
                return .success(rows)
            case .failure(let error):
                return .failure(error)
            }
        } catch {
            print(error)
            return .failure(error)
        }
    }
    
    /// Returns raw data
    /// - Returns: Raw data or error
    func getData(url: URL) async -> Result<Data, Error> {
        guard let result = await requestDispatcher.dispatch(
            with: url.absoluteString,
            requestType: RequestType.requestGet,
            parameters: [:],
            requestBody: nil
        ) else {
            return .failure(NetworkError.badRequest)
        }
        
        switch result {
        case .success(let data):
            return .success(data)
        case .failure(let error):
            return .failure(error)
        }
    }
}
