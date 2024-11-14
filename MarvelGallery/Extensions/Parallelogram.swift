//
//  Parallelogram.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 14/11/2024.
//

import SwiftUI

struct Parallelogram: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let slant: CGFloat = 8 

        path.move(to: CGPoint(x: slant, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width - slant, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()

        return path
    }
}
