//
//  BaseModel.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 29.11.2022.
//

import GRDB
import SwiftUI

// MARK: A Model parent to use from API to SQLite
protocol BasicModel: Codable, Identifiable, FetchableRecord, MutablePersistableRecord, Equatable {
    var id: String { get set }
}

// MARK: A BasicModel shared properties
extension BasicModel {
    // MARK: A row update|insert policy
    public static var persistenceConflictPolicy: PersistenceConflictPolicy {
        PersistenceConflictPolicy(insert: .replace, update: .replace)
    }
    
    // MARK: The Model is empty or new
    var isEmpty: Bool {
        return id.isEmpty
    }
}
