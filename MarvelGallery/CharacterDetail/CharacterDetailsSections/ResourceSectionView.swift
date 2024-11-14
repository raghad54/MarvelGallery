//
//  ResourceSectionView.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 14/11/2024.
//

import SwiftUI

struct ResourceSectionView: View {
    let title: String
    let items: [MarvelResourceItem]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.red)
                .padding(.horizontal)

            ScrollView(.horizontal) {
                HStack {
                    ForEach(items) { item in
                        VStack {
                            AsyncImage(url: URL(string: item.imageUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .clipped()
                            } placeholder: {
                                Color.gray.frame(width: 150, height: 150)
                            }

                            Text(item.name)
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .padding(.top, 8)
                        }
                        .padding(.horizontal, 4)
                    }
                }
            }
            .padding(.bottom)
        }
    }
}
