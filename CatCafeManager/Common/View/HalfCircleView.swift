//
//  HalfCircleView.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 28.02.2024.
//

import Foundation
import SwiftUI

/// Returns a half circle view
struct HalfCircleView: View {
    var percent: Float = 100.0
    
    var body: some View {
        HalfCircle(start: .degrees(-180), end: .degrees(Double(percent * 1.8) - 180.0) )
    }
}

/// Returns a half circle shape
struct HalfCircle: Shape {
    var start: Angle
    var end: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: center)
        path.addArc(center: center, radius: rect.midX, startAngle: start, endAngle: end, clockwise: false)
        return path
    }
}
