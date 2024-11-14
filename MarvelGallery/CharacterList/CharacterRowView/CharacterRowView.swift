//
//  CharacterRowView.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 13/11/2024.
//

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
            
            GeometryReader { geometry in
                let textWidth = min(geometry.size.width - 70, 220) - 60

                Parallelogram()
                    .fill(Color.white)
                    .frame(width: textWidth, height: 40)
                    .offset(x: 10, y: 15)

                Text(character.name)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.black)
                    .frame(width: textWidth, height: 40)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(15)
            }
            .frame(height: 70)
            .padding(.bottom, 10)
            .padding(.leading, 20)
        }
        .padding(.horizontal)
    }
}

