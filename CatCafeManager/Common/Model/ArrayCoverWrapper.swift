//
//  ArrayCoverWrapper.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 11.09.2023.
//

import Foundation

/// A struct for decoding a top level struct with a dynamic array
struct ArrayCoverWrapper<T: BasicModel>: BasicModel {
    var id: String = UUID().uuidString.lowercased()
    var covered: ArrayWrapper<T>!
  
    /// Custom CodingKeys
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int?
        init?(intValue: Int) {
            nil
        }
    }
    
    /// Decodes generic struct
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        for key in container.allKeys {
            if let keys = DynamicCodingKeys(stringValue: key.stringValue) {
                covered = try? container.decode(ArrayWrapper<T>.self, forKey: keys)
            }
        }
    }
    
    /// Equatable implementation
    static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}

extension ArrayCoverWrapper {
    var coveredValue: ArrayWrapper<T> {
        if covered != nil {
            return covered
        } else {
            return ArrayWrapper(array: [T]())
        }
    }
}
