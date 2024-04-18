//
//  Swift_5_9_tests.swift
//  CatCafeManagerTests
//
//  Created by VitaliusSch on 21.12.2023.
//

import XCTest
@testable import CatCafeManager

final class Swift59Tests: XCTestCase {
    struct User {
        var name: String
    }
    
    func testExample() {
        func createAndGreetUser() {
            let user = User(name: "Anonymous")
            greet(user)
            print("Goodbye, \(user.name)")
        }

        func greet(_ user: borrowing User) {
            print("Hello, \(user.name)!")
        }

        createAndGreetUser()
    }
    
    func testGCD() {
        func someprint(_ i: Int) {
            print("\(i) -----------------------")
            print("\(i) 1")
            
            DispatchQueue.global().async {
                print("\(i) 2")
            }
            
            print("\(i) 3")
        }
        
        for i in 0...9 {
            someprint(i)
            //sleep(1)
        }
    }
}
