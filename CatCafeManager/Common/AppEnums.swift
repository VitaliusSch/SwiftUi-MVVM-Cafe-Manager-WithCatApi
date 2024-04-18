//
//  AppEnums.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 10.01.2023.
//

enum RequestType: String {
    case requestPost = "POST"
    case requestGet = "GET"
    case requestPut = "PUT"
    case requestDelete = "DELETE"
}

enum NetworkError: Error {
    case needRefreshToken
    case invalidLogin
    case invalidPassword
    case invalidURL
    case missingData
    case badResponse
    case timeout
}

enum CustomError: Error {
    case runtimeError(String)
}
