//
//  FakeCatApi.swift
//  CatCafeManagerTests
//
//  Created by VitaliusSch on 02.03.2023.
//

import Foundation
@testable import CatCafeManager

class MockCatsApi: RequestDispatcherProtocol {
    func dispatch(
        with endpoint: String,
        requestType: CatCafeManager.RequestType,
        parameters: [String: Any],
        requestBody: Data?
    ) async -> Result<Data, Error>? {
        if endpoint == AppRoutes.Cats {
            let mockData = Data("[{\"id\":\"306\",\"url\":\"https://cdn2.thecatapi.com/images/306.jpg\",\"width\":2048,\"height\":1536}]".utf8)
            let decoder = JSONDecoder()
            let encoder = JSONEncoder()
            guard let decoded: [CatModel] = try? decoder.decode([CatModel].self, from: mockData) else {
                return .failure(NetworkError.decodingError("decode Cats error"))
            }
            guard let encodedData: Data = try? encoder.encode(decoded) else {
                return .failure(NetworkError.decodingError("encode Cats error"))
            }
            return .success(encodedData)
        }
        return .failure(NetworkError.notFound)
    }
}
