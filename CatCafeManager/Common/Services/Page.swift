//
//  Page.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 09.03.2023.
//

import Foundation

/// A helper struct for decoding
struct Page<T: Codable>: Codable {
    private let pageSize: Int
    private var currentPage: Int
    private var rowsOptional: [T]?
    
    init(pageSize: Int = 10, currentPage: Int = 0, fetching: Bool = false, rowsOptional: [T]? = nil) {
        self.pageSize = pageSize
        self.currentPage = currentPage
        self.rowsOptional = rowsOptional
    }
}

extension Page {
    var rows: [T] {
        get {
            return rowsOptional ?? []
        }
        set {
            rowsOptional = newValue
        }
    }
    
    mutating func appendRows(newRow: T) {
        self.rows.append(newRow)
    }
    
    func getCurrentPage() -> Int {
        return self.currentPage
    }
    
    mutating func increasePage() {
        self.currentPage += 1
    }
    
    func getPageSize() -> Int {
        return self.pageSize
    }
    
    func makeParams() -> [String: Any] {
        var params: [String: Any] = [:]
        params[AppConstants.Page.PageSize] = "\(getPageSize())"
        params[AppConstants.Page.PageNumber] = "\(getCurrentPage())"
        // this parameter needs to get ordered array
        params[AppConstants.Page.PageOrder] = "ASC"
        // this parameter needs to access the API and get ordered array
        params[AppConstants.AccessKey.AccessKeyParameterCaption] = AppConstants.AccessKey.AccessKey
        
        return params
    }
}
