//
//  MockCatRepositopy.swift
//  CatCafeManagerTests
//
//  Created by VitaliusSch on 08.04.2024.
//

import Foundation
@testable import CatCafeManager
import GRDB

struct MockCatRepositopy: RepositoryProtocol {
    var tableName: String
    
    var database: CatCafeManager.SQLiteRepository
    
    func migration(migrationName: String, db: Database, object: Any) throws {
        
    }
    
    func getAsync<T: FetchableRecord>(stringParam: String) async -> [T] {
        if stringParam.contains(" cafeId = ") {
            return [
                CatModel(id: "1", url: "https://cdn2.thecatapi.com/images/1.jpg", width: 0, height: 0, name: "mew", cafeId: "1", adoptCost: 22) as! T,
                CatModel(id: "2", url: "https://cdn2.thecatapi.com/images/2.jpg", width: 0, height: 0, name: "the cat", cafeId: "1", adoptCost: 15) as! T
            ]
        } else {
            return []
        }
    }
    
    func createAsync<T: MutablePersistableRecord>(entities: [T]) async -> Bool {
        return true
    }
    
}
