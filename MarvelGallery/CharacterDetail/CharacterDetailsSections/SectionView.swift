//
//  SectionView.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 14/11/2024.
//

import SwiftUI

struct SectionView: View {
    let title: String
    let items: [MarvelResourceItem]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.red)
                .padding(.leading)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(items) { item in
                        VStack {
                            AsyncImage(url: URL(string: item.imageUrl)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 150)
                                    .cornerRadius(8)
                            } placeholder: {
                                Color.gray
                                    .frame(width: 100, height: 150)
                                    .cornerRadius(8)
                            }

                            Text(item.name)
                                .font(.caption)
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .frame(width: 100)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom)
    }
}
