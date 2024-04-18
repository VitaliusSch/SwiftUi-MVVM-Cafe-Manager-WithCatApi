//
//  SQLiteRepository.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 11.01.2023.
//

import Foundation
import GRDB

/// This repository is required for operaion with the database
final class SQLiteRepository {
    static var shared = SQLiteRepository()
    private var allRepositories = [RepositoryProtocol]()
    // Migration list. Just add new version and a new handler in the repo
    private let migrationNames = ["init", "Version_1", "Version_2", "Version_3"]

    private var _db: DatabasePool!
    var db: DatabasePool {
        return _db
    }

    /// create/open and migrate the db
    func setUp() throws {
        _db = try setupDatabase(inFile: "CatCafeDB.sqlite")
        
        try migrator.migrate(_db)
    }
    
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        // TODO: Just uncomment this to wipe the database
//        migrator.eraseDatabaseOnSchemaChange = true
//        do {
//            try _db.erase()
//        } catch {
//            print("error erasing db: \(error)")
//        }

        for migrationName in migrationNames {
            migrator.registerMigration(migrationName) { [allRepositories] db in
                for repo in allRepositories {
                    try (repo as RepositoryProtocol).migration(migrationName: migrationName, db: db, object: self)
                }
            }
        }

        return migrator
    }
    
    private func setupDatabase(inFile file: String) throws -> DatabasePool {
        let databaseURL = try FileManager.default
            .url(for: .applicationSupportDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: true)
            .appendingPathComponent(file)
        return try DatabasePool(path: databaseURL.path)
    }
    
    func addRepoToMigration(repo: RepositoryProtocol) {
        allRepositories.append(repo)
    }
}
