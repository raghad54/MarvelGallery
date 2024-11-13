//
//  GoToButtomModifiers .swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 14/11/2024.
//

import Foundation
import SwiftUI

struct OnReachBottomModifier: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .background(GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        let frame = proxy.frame(in: .global)
                        let bottom = frame.maxY
                        let screenHeight = UIScreen.main.bounds.height
                        if bottom < screenHeight {
                            action()
                        }
                    }
            })
    }
}

extension View {
    func onReachBottom(perform action: @escaping () -> Void) -> some View {
        self.modifier(OnReachBottomModifier(action: action))
    }
}
