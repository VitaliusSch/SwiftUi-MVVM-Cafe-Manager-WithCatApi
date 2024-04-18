//
//  Enum.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 07.09.2023.
//

import Foundation

/// Emuns protocol
public protocol EnumExtension: CaseIterable, RawRepresentable {
    static func fromString(stringValue: String, defaultValue: Self?) -> Self
}

extension EnumExtension {
    /// An universal enum parsing
    ///
    ///     //  Sample
    ///     enum SomeEnum: String, EnumExtension {
    ///         case firstCase = "FirstCase"
    ///         case secondCase = "SecondCase"
    ///         case defaultCase = "defaultCase"
    ///     }
    ///     let someEnumValue = SomeEnum.fromString(stringValue: "FirstCase", defaultValue: .defaultCase)
    ///
    /// - Parameter stringValue: A string value
    /// - Returns: parsed enum value
    static func fromString(stringValue: String, defaultValue: Self? = nil) -> Self.AllCases.Element {
        var returnValue: Self.AllCases.Element
        if let defaultValue = defaultValue {
            returnValue = defaultValue
        } else {
            returnValue = Self.allCases[Self.allCases.startIndex]
        }
        
        for eachCase in Self.allCases {
            if stringValue == "\(eachCase.rawValue)" {
                returnValue = eachCase
            }
        }
        return returnValue
    }
}
