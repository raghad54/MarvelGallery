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
            
            Text(character.name)
                .font(.title2)
                .bold()
                .foregroundColor(.black)
                .padding(10)
                .background(.white)
                .cornerRadius(10)
                .padding(10)
        }
    }
}
