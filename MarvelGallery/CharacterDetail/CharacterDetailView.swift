//
//  CharacterDetailView.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 13/11/2024.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: CharacterListModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
        
            
            ScrollView {
                VStack(spacing: 20) {
                    // Custom Back Button
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size: 30))
                        }
                        Spacer()
                    }
                    .padding(.top, 16)
                    .padding(.horizontal)
                    AsyncImage(url: character.imageUrl) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .clipped()
                            .edgesIgnoringSafeArea(.top)
                        
                    } placeholder: {
                        Color.gray.frame(maxWidth: .infinity, maxHeight: 300)
                            .edgesIgnoringSafeArea(.top)
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Name")
                            .font(.system(size: 16))
                            .foregroundColor(.red)
                        
                        Text(character.name)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Character Description
                    VStack(alignment: .leading, spacing: 10) {
                        if character.description.isEmpty {
                            Text("No description available.")
                                .italic()
                                .foregroundColor(.gray)
                        } else {
                            Text("Description")
                                .font(.system(size: 16))
                                .foregroundColor(.red)
                            Text(character.description)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Comics Section
                    if !character.comics.items.isEmpty {
                        SectionView(title: "Comics", items: character.comics.items)
                    }
                    
                    // Series Section
                    if !character.series.items.isEmpty {
                        SectionView(title: "Series", items: character.series.items)
                    }
                    
                    // Stories Section
                    if !character.stories.items.isEmpty {
                        SectionView(title: "Stories", items: character.stories.items)
                    }
                    
                    // Events Section
                    if !character.events.items.isEmpty {
                        SectionView(title: "Events", items: character.events.items)
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Related Links")
                            .font(.system(size: 16))
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .padding(.top, 10)
                        SectionWithArrowView(title: "Linked Details", action: {})
                        SectionWithArrowView(title: "Wiki" , action: {})
                        SectionWithArrowView(title: "Comic Link", action: {})
                    }
                        .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true) // Hides the default navigation bar
        }
    }
}
