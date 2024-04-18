//
//  MapKitSearcherTest.swift
//  CatCafeManagerTests
//
//  Created by VitaliusSch on 26.06.2023.
//

import XCTest
@testable import CatCafeManager

final class MapKitSearcherTest: XCTestCase {
    func testExample() async {
        AppFactory.shared.setUp(customContainer: nil)
        MapKitSearcher().search(searchString: "Cat cafes")
        try? await Task.sleep(nanoseconds: 1000)
    }
}
