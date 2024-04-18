//
//  CatModel.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 29.11.2022.
//
// sample: "id":"10s","url":"https://cdn2.thecatapi.com/images/10s.jpg","width":500,"height":815

import GRDB
import Foundation

/// A cat model
struct CatModel: BasicModel, ImageProtocol {
    var id: String
    let url: String
    let width: Int
    let height: Int
    var name: String!
    var cafeId: String!
    var adoptCost: Int!
}

extension CatModel {
    var imageURL: URL? {
        URL(string: url)
    }
    var adoptCostWrapped: Int {
        return adoptCost ?? 0
    }
    var nameWrapped: String {
        return name ?? ""
    }
    static var aNewCat: CatModel {
        CatModel(id: "", url: "", width: 0, height: 0, name: "", cafeId: "", adoptCost: 0)
    }
    // These properties below are necessary until their analogues appear in the API
    static var randomName: String {
        AppConstants.Cat.Names.randomElement() ?? ""
    }
    static var randomCost: Int {
        Int.random(in: 20...30)
    }
}

extension CatModel: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

// To sort any cat-array
extension CatModel {
  enum Comparison {
      static let nameAsc: (CatModel, CatModel) -> Bool = {
          return ($0.nameWrapped.localizedCaseInsensitiveCompare($1.nameWrapped) == .orderedAscending)
      }
      static let nameDesc: (CatModel, CatModel) -> Bool = {
          return ($0.nameWrapped.localizedCaseInsensitiveCompare($1.nameWrapped) == .orderedDescending)
      }
      static let idAsc: (CatModel, CatModel) -> Bool = {
          return ($0.id) < ($1.id)
      }
      static let idDesc: (CatModel, CatModel) -> Bool = {
          return ($0.id) > ($1.id)
      }
  }
}
