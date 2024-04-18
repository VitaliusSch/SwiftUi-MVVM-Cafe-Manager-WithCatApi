//
//  CafeRepository.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 12.12.2022.
//

import Foundation
import GRDB

// This repository is required for fetching and writing cafes
struct CafeRepository: RepositoryProtocol {
    var tableName: String
    var database: SQLiteRepository
    
    func migration(migrationName: String, db: Database, object: Any) throws {
        try self.migrationInit(migrationName: migrationName, db: db, object: CafeModel(id: "", title: "", latitude: 0, longitude: 0))
    
        if migrationName == "Version_1" {
            // TODO: migrate to Version 1
        }
    }
}
