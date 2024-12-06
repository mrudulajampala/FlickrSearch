//
//  PhotoGridView.swift
//  FlickrSearch
//
//  Created by Mrudula on 12/6/24.
//

import SwiftUI

struct PhotoGridView: View {
    let photo: FlickrPhoto
    
    var body: some View {
        AsyncImage(url: URL(string: photo.media.m)) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: 108, height: 108)
                .accessibilityLabel(photo.title)
                .accessibilityAddTraits(.isButton)
                .accessibilityRemoveTraits(.isImage)
        } placeholder: {
            ProgressView()
                .frame(width: 108, height: 108)
                .background(Color.gray.opacity(0.1))
        }
        .clipped()
        .contentShape(Rectangle())
    }
}


