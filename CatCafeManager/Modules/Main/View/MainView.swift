//
//  ContentView.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 25.11.2022.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var cafeViewModel = AppFactory.shared.resolve(CafeViewModel.self)
    @StateObject var mainViewModel = AppFactory.shared.resolve(MainViewModel.self)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapView()
            TopView()
            CafeListView(viewModel: cafeViewModel)
        }
        .navigationBarHidden(true)
        if mainViewModel.isLoading {
            LoadingView()
                .modifier(modBackStack)
                .background(.black.opacity(0.8))
        }
    }
    
    /// iOS 15 custom color and settings
    func setAppearance15() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(.lightGray)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(.lightGray)]
        UINavigationBar.appearance().tintColor = UIColor(.lightGray)

        UISearchBar.appearance().tintColor = UIColor(.lightGray)
        
        let standardAppearance = UITabBarAppearance()
        standardAppearance.backgroundColor = UIColor(.lightGray)
        standardAppearance.shadowColor = UIColor(.black.opacity(0.3))
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor(.lightBack)
        itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(.lightBack)]
        
        itemAppearance.selected.iconColor = UIColor(.selectedFg)
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(.selectedFg)]
        
        standardAppearance.inlineLayoutAppearance = itemAppearance
        standardAppearance.stackedLayoutAppearance = itemAppearance
        standardAppearance.compactInlineLayoutAppearance = itemAppearance
        UITabBar.appearance().standardAppearance = standardAppearance
        UITabBar.appearance().scrollEdgeAppearance = standardAppearance

        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().contentInset.top = -35
        UITableView.appearance().sectionFooterHeight = 0
        UITableView.appearance().sectionHeaderHeight = 5
        
        UITextView.appearance().backgroundColor = .clear
    }
}
