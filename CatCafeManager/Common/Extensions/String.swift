//
//  String.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 27.02.2024.
//

import Foundation

extension String {
    /// Formats the string with values
    /// - Parameter arguments: parameters to replace in string
    /// - Returns: formatted string
    func withFormat(_ arguments: [CVarArg]) -> String {
        String(
            format: NSLocalizedString(self, comment: ""),
            arguments: arguments
        )
    }
    /// Checks the string with pattern
    /// - Parameter pattern: patter to check
    /// - Returns: matches or not
    /// email sample 
    /// "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
    /// "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
    /// "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
    /// "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    /// characters
    ///  ".*[A-Z]+.*" ".*[a-z]+.*"
    func regexContains(pattern: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }
}
