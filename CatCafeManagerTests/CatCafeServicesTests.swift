//
//  CatCafeMangerTests.swift
//  CatCafeMangerTests
//
//  Created by VitaliusSch on 25.11.2022.
//

import XCTest
@testable import CatCafeManager
import Swinject

/// Some Services tests
final class CatCafeServicesTests: XCTestCase {
    private let container = Container()
    override func setUp() {
        container.register(Service.self) { _, route in Service(route: route, requestDispatcher: MockCatsApi()) }
           .inObjectScope(.transient)
    }

    func testCatsApiGet() async {
        let catsService = container.resolve(Service.self, argument: AppRoutes.Cats)!
        let page = Page<CatModel>(pageSize: 15, currentPage: 1, rowsOptional: [])
        let catsResult: Result<[CatModel], Error> = await catsService.get(parameters: page.makeParams())
        if case .success(let cats) = catsResult {
            XCTAssertEqual(cats.count, 1)
            XCTAssertEqual(cats[0].id, "306")
        } else {
            XCTAssertEqual(true, false)
        }
    }

}
