//
//  TextView.swift
//  CatCafeManager
//
//  Created by Mac on 03.06.2024.
//

import Foundation
import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String
    var fontStyle: UIFont.TextStyle
    var isEditable: Bool
    var backgroundColor: UIColor
    var foregroundColor: UIColor
    
    func makeUIView(context: UIViewRepresentableContext<TextView>) -> UITextView {
        let textView = UIKitTextView()
        
        textView.font = UIFont.preferredFont(forTextStyle: fontStyle)
        textView.isEditable = isEditable
        textView.backgroundColor = backgroundColor
        textView.textColor = foregroundColor
        textView.delegate = context.coordinator
        textView.autocorrectionType = .no
        
        return textView
    }
    
    func updateUIView(_ textView: UITextView, context: UIViewRepresentableContext<TextView>) {
        if textView.text != self.text {
            textView.text = self.text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    private final class UIKitTextView: UITextView {
        override var contentSize: CGSize {
            didSet {
                invalidateIntrinsicContentSize()
            }
        }
        
        override var intrinsicContentSize: CGSize {
            CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
        }
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        
        init(text: Binding<String>) {
            self.text = text
        }
        
        func textViewDidChange(_ textView: UITextView) {
            text.wrappedValue = textView.text
        }
    }
}
