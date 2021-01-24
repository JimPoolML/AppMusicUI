//
//  SimpleBlurEffect.swift
//  AppMusic
//
//  Created by Jim Pool Moreno on 18/01/21.
//

import Foundation
import SwiftUI

//MARK: --Blur
//https://medium.com/@edwurtle/blur-effect-inside-swiftui-a2e12e61e750
struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
