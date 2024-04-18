//
//  FakeBreedsApi.swift
//  CatCafeManagerTests
//
//  Created by VitaliusSch on 02.03.2023.
//

import Foundation
@testable import CatCafeManager

class MockBreedsApi: RequestDispatcherProtocol {
    func dispatch(with endpoint: String, requestType: CatCafeManager.RequestType, parameters: [String : Any], requestBody: Data?) async -> Result<Data, Error>? {
        return .failure(NetworkError.decodingError("No data to decode"))
    }
    
}
