//
//  MockCafeRepository.swift
//  CatCafeManagerTests
//
//  Created by VitaliusSch on 16.04.2024.
//

import Foundation
@testable import CatCafeManager
import GRDB

struct MockCafeRepository: RepositoryProtocol {
    var tableName: String
    
    var database: CatCafeManager.SQLiteRepository
    
    func migration(migrationName: String, db: Database, object: Any) throws {
        
    }
    
    func getAsync<T: FetchableRecord>(stringParam: String) async -> [T] {
        return [
                CafeModel(id: "134", title: "Mew's cafe", latitude: -0.34, longitude: 8.33) as! T
        ]
    }
    
    func getAsync<T: FetchableRecord>() async -> [T] {
        return [
                CafeModel(id: "134", title: "Mew's cafe", latitude: -0.34, longitude: 8.33) as! T
        ]
    }

    func createAsync<T: MutablePersistableRecord>(entities: [T]) async -> Bool {
        return true
    }
    
}
