//
//  BoxWrapper.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 12.02.2024.
//

// A generic class to avoid recursiveness
// example
//  struct SomeCat: Codable {
//     var catWrapped: BoxWrapper<SomeCat>!
//
//     var cat: SomeCat {
//        get {
//            catWrapped?.wrappedValue ?? SomeCat()
//        }
//        set {
//            if catWrapped == nil {
//                catWrapped = BoxWrapper(value: newValue)
//            } else {
//                catWrapped.wrappedValue = newValue
//            }
//        }
//      }
///  }
class BoxWrapper<T: Codable>: Codable {
    var wrappedValue: T
    required init(from decoder: Decoder) throws {
        wrappedValue = try T(from: decoder)
    }
    
    func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
    
    init(value: T) {
        wrappedValue = value
    }
}

extension BoxWrapper: Equatable where T: Equatable {
    static func == (lhs: BoxWrapper<T>, rhs: BoxWrapper<T>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
