//
//  LoadingView.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 26.12.2022.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Text("Loading")
                .padding(.bottom, 120)
                .font(.appFont20)
                .foregroundColor(Color.secondary)
            ActivityIndicator(isAnimating: .constant(true), style: .large)
        }
    }
}

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        if isAnimating {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}
