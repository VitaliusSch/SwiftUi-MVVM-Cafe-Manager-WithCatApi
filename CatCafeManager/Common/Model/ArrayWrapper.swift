//
//  ArrayWrapper.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 11.09.2023.
//

import Foundation

/// A struct for decoding a dynamic array
struct ArrayWrapper<T: Codable>: Codable {
    var array: [T]!
  
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
    
    /// Decodes generic array
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        for key in container.allKeys {
            do {
                if key.stringValue.isEmpty {
                    array = []
                } else {
                    if let keys = DynamicCodingKeys(stringValue: key.stringValue) {
                        array = try container.decode([T].self, forKey: keys)
                    }
                }
            } catch {
                array = []
                print(error)
            }
        }
    }
    
    /// Inits array with incoming value
    init(array: [T]) {
        self.array = array
    }
}

extension ArrayWrapper {
    /// Unwrapping array
    var arrayValue: [T] {
        return array ?? [T]()
    }
}
