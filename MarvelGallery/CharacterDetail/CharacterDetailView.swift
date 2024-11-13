//
//  CharacterDetailView.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 13/11/2024.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: CharacterListModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Character Image
                if let url = URL(string: "\(character.thumbnail.path).\(character.thumbnail.extension)") {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                            .clipped()
                    } placeholder: {
                        Color.gray
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                    }
                } else {
                    Color.gray
                        .frame(width: UIScreen.main.bounds.width, height: 300)
                }
                
                // Character Info
                VStack(alignment: .leading, spacing: 8) {
                    Text("NAME")
                        .font(.caption)
                        .foregroundColor(.red)
                    
                    Text(character.name)
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("DESCRIPTION")
                        .font(.caption)
                        .foregroundColor(.red)
                    
                    Text(character.description.isEmpty ? "No description available." : character.description)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                }
                .padding()
                
                // Comics Section
                Text("COMICS")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding(.leading, 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(0..<5) { _ in
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 100, height: 150)
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

