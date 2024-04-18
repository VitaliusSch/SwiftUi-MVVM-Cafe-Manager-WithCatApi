//
//  CatCafeNimbleTest.swift
//  CatCafeManagerTests
//
//  Created by VitaliusSch on 06.06.2023.
//

import Quick
import Nimble
import Swinject
@testable import CatCafeManager

final class CatCafeNimbleTest: AsyncSpec {
    override class func spec() {
        let container = Container()

        container.register(Service.self) { _, route in Service(route: route, requestDispatcher: MockCatsApi()) }
            .inObjectScope(.transient)

        let catsService = container.resolve(Service.self, argument: AppRoutes.Cats)!
        it("The Service can be resolved") {
            expect(catsService).toNot(beNil())
        }

        it("The returned page must contain lines") {
            let page = Page<CatModel>(pageSize: 15, currentPage: 1, rowsOptional: [])
            let catsResult: Result<[CatModel], Error> = await catsService.get(parameters: page.makeParams())
            if case .success(let cats) = catsResult {
                await expect(cats.count).toEventually(equal(1))
                await expect(cats[0].id).toEventually(equal("306"))
            }
        }
    }
}
