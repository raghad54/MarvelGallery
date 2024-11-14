//
//  CharacterRowView.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 13/11/2024.
//

import Foundation
import SwiftUI

struct CharacterRowView: View {
    let character: CharacterListModel
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background Image
            if let url = character.imageUrl {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width, height: 170)
                        .clipped()
                } placeholder: {
                    Color.gray
                        .frame(width: UIScreen.main.bounds.width, height: 170)
                }
            } else {
                Color.gray
                    .frame(width: UIScreen.main.bounds.width, height: 170)
            }
            
            // Parallelogram Shape with Dynamic Width based on Text
            GeometryReader { geometry in
                // Reduce width by 10 points from the calculated textWidth
                let textWidth = min(geometry.size.width - 70, 230) - 25 // Decrease width by 10
                
                Parallelogram()
                    .fill(Color.white)
                    .frame(width: textWidth, height: 40) // Adjust the height for text
                    .offset(x: 10, y: 15) // Keep space for text
                
                // Text inside the parallelogram with added top padding
                Text(character.name)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.black)
                    .frame(width: textWidth, height: 40)
                    .multilineTextAlignment(.center)
                    .lineLimit(2) // Allow wrapping for long text
                    .padding(.horizontal, 5) // Padding for the text inside the parallelogram
                    .padding(.top, 10) // Add top padding to push the text down a bit
                    .padding(.bottom, 5) // Keep some bottom padding for text
            }
            .frame(height: 70) // Adjust the height for the parallelogram container
            .padding(.bottom, 10) // Padding at the bottom of the shape to separate it from the content below
        }
        .padding(.horizontal) // Add horizontal padding for the entire view
    }
}

struct Parallelogram: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let slant: CGFloat = 8 // Slant angle for the parallelogram

        path.move(to: CGPoint(x: slant, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width - slant, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()

        return path
    }
}
