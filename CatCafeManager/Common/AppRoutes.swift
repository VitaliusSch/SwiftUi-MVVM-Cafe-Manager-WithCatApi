//
//  AppRoutes.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 17.01.2023.
//
// v1/images/search?order=ASC&page=1&limit=10
// x-api-key live_Xhr23uL2hBfjBEhv6YMgyCXEtVNE505J5crjIAIN2KlswJNCgU5k8l6ecDGPORoO

enum AppRoutes {
    public static let BasicURL = "https://api.thecatapi.com/v1"
    public static let Files = "https://cdn2.thecatapi.com/images/"
    public static let Breeds = BasicURL + "/breeds"
    public static let Cats = BasicURL + "/images/search"
}
