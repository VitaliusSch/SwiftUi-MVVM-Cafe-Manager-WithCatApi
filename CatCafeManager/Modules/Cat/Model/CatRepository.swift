//
//  CatsRepository.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 09.03.2023.
//

import Foundation
import GRDB

// This Cats-repository is required for fetching cats from Api and writing to SQLight
struct CatRepository: RepositoryProtocol {
    var tableName: String
    var database: SQLiteRepository
    
    public func migration(migrationName: String, db: Database, object: Any) throws {
        try self.migrationInit(migrationName: migrationName, db: db, object: CatModel.aNewCat)

        if migrationName == "Version_3" {
            do { try db.execute(sql: "ALTER TABLE catModel ADD COLUMN cafeId TEXT") } catch {}
            do { try db.execute(sql: "ALTER TABLE catModel ADD COLUMN adoptCost INTEGER") } catch {}
        }
// TODO: The sample of migration for new table
//        if (migrationName == "v03") {
//            do { try db.drop(table: self.tableName) } catch {}
//            do { try createTable(db: db, object: CatModel(id: "")) } catch {}
//        }
    }
    
//    override public func migration(migrationName: String, db: Database, object: Any) throws {
//        try super.migration(migrationName: migrationName, db: db, object: CatModel.aNewCat)
//
//        if migrationName == "Version_3" {
//            do { try db.execute(sql: "ALTER TABLE catModel ADD COLUMN cafeId TEXT") } catch {}
//            do { try db.execute(sql: "ALTER TABLE catModel ADD COLUMN adoptCost INTEGER") } catch {}
//        }
//// TODO: The sample of migration for new table
////        if (migrationName == "v03") {
////            do { try db.drop(table: self.tableName) } catch {}
////            do { try createTable(db: db, object: CatModel(id: "")) } catch {}
////        }
//    }
}
