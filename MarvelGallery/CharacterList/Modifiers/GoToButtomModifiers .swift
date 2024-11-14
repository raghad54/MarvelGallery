//
//  GoToButtomModifiers .swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 14/11/2024.
//

import SwiftUI

struct OnReachBottomModifier: ViewModifier {
    let action: () -> Void
    
    @State private var isTriggered = false
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onChange(of: proxy.frame(in: .global).maxY) { maxY in
                            let screenHeight = UIScreen.main.bounds.height
                            let triggerOffset: CGFloat = screenHeight * 0.8
                            if maxY < screenHeight + triggerOffset && !isTriggered {
                                isTriggered = true
                                action()
                            } else if maxY > screenHeight + triggerOffset {
                                isTriggered = false
                            }
                        }
                }
            )
    }
}

extension View {
    func onReachBottom(perform action: @escaping () -> Void) -> some View {
        self.modifier(OnReachBottomModifier(action: action))
    }
}
