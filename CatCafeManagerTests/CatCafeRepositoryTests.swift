//
//  CatCafeRepositoryTests.swift
//  CatCafeManagerTests
//
//  Created by VitaliusSch on 12.03.2024.
//

import XCTest
@testable import CatCafeManager
import Swinject
import GRDB

/// Some SQLight integration tests
final class CatCafeRepositoryTests: XCTestCase {
    private let container = Container()
    private let sqLite = SQLiteRepository()
    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
        container.register(CafeRepository.self) { _ in CafeRepository(tableName: "cafeModel", database: self.sqLite) }
            .inObjectScope(.weak)

        sqLite.addRepoToMigration(repo: container.resolve(CafeRepository.self)!)

        container.register(CatRepository.self) { _ in CatRepository(tableName: "catModel", database: self.sqLite) }
            .inObjectScope(.weak)

        sqLite.addRepoToMigration(repo: container.resolve(CatRepository.self)!)

        try? sqLite.setUp()
    }
    
    func testCafeRepo() async {
        let cafeRepo = container.resolve(CafeRepository.self)!
        var cafe = CafeModel(id: "222", title: "Some cafe", latitude: 100, longitude: -100)
        
        let created = await cafeRepo.createAsync(entities: [cafe])
        XCTAssertTrue(created)
        
        var result:[CafeModel] = await cafeRepo.getAsync(stringParam: " id = '\(cafe.id)'")
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].id, cafe.id)
        
        cafe.title = "Super cafe"
        let updated = await cafeRepo.createAsync(entities: [cafe])
        XCTAssertTrue(updated)
        
        result = await cafeRepo.getAsync(stringParam: " id = '\(cafe.id)'")
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].title, cafe.title)
    }
    
    func testCatRepo() async {
        let cateRepo = container.resolve(CatRepository.self)!
        var cat = CatModel(id: "wc22", url: "", width: 100, height: 100, name: "Mew Mew", cafeId: "222", adoptCost: 25)
        
        let created = await cateRepo.createAsync(entities: [cat])
        XCTAssertTrue(created)
        
        var result:[CatModel] = await cateRepo.getAsync(stringParam: " id = '\(cat.id)'")
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].id, cat.id)
        
        cat.name = "Tristan"
        let updated = await cateRepo.createAsync(entities: [cat])
        XCTAssertTrue(updated)
        
        result = await cateRepo.getAsync(stringParam: " id = '\(cat.id)' AND cafeId = '222' ")
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].name, cat.name)
    }

}

