//
//  BaseRepository.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 06.12.2022.
//

import Foundation
import GRDB
import SwiftUI

protocol RepositoryProtocol {
    var tableName: String { get set }
    var database: SQLiteRepository { get set }
    
    init()
    init(tableName: String, database: SQLiteRepository)
    
    /// Auto-creation table
    func migration(migrationName: String, db: Database, object: Any) throws
    
    /// Inserts rows into DB async
    func createAsync<T: MutablePersistableRecord>(entities: [T]) async -> Bool
    /// Gets rows from DB async
    func getAsync<T: FetchableRecord>(stringParam: String) async -> [T]
}

extension RepositoryProtocol {
    init() {
        self.init(tableName: "", database: SQLiteRepository())
    }

    /// Auto-creation table
    /// - Parameters:
    ///   - migrationName: migrationName
    ///   - db: instance DB
    ///   - object: instance of entity
    func migrationInit(migrationName: String, db: Database, object: Any) throws {
        if migrationName == "init" {
            try createTable(db: db, object: object)
        }
    }
    
    /// Creates the table in the DB
    /// - Parameters:
    ///   - db: instance DB
    ///   - object: entity for table
    private func createTable(db: Database, object: Any) throws {
        let mirror = Mirror(reflecting: object)
        
        try db.create(table: self.tableName) { table in
            for child in mirror.children {
                if child.label == "id" {
                    table.column(child.label!, .text).primaryKey() // TODO: decode type
                } else {
                    table.column(child.label!, .text) // TODO: decode type
                }
            }
        }
    }
    
    /// Inserts rows into DB async
    /// - Parameter entities: entities for insert
    func createAsync<T: MutablePersistableRecord>(entities: [T]) async -> Bool {
        do {
            try await database.db.write({ db in
                for entity in entities {
                    var entityR = entity
                    try entityR.insert(db)
                }
            })
            return true
        } catch {
            return false
        }
    }
    
    /// Gets rows from DB async
    /// - Returns: array of entities
    func getAsync<T: FetchableRecord>(stringParam: String = "") async -> [T] {
        do {
            return try await database.db.read { db in
                var entities: [T] = []
                if stringParam.isEmpty {
                    entities = try T.fetchAll(db, sql: "SELECT * FROM " + self.tableName)
                } else {
                    entities = try T.fetchAll(db, sql: "SELECT * FROM " + self.tableName + " WHERE " + stringParam)
                }
                return entities
            }
        } catch {
            print("\(error)")
        }
        return []
    }
}
