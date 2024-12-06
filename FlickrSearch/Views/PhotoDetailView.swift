//
//  PhotoDetailView.swift
//  FlickrSearch
//
//  Created by Mrudula on 12/6/24.
//

import SwiftUI

struct PhotoDetailView: View {
    let photo: FlickrPhoto
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: photo.media.originalURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .accessibilityLabel(photo.title)
                        .accessibilityAddTraits(.isImage)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(photo.title)
                        .accessibilityLabel(photo.title)
                        .font(.title2)
                        .bold()
                    
                    Text("Description : \(photo.description)")
                        .accessibilityLabel(photo.description)
                        .font(.footnote)
                        .foregroundColor(.indigo)
                        .bold()
                    
                    Text("Taken By : \(photo.author)")
                        .accessibilityLabel("Photo taken By : \(photo.author)")
                        .font(.subheadline)
                        .foregroundColor(.indigo)
                        .bold()
                    
                    Text("Taken On :\(formatDate(photo.dateTaken))")
                        .accessibilityLabel("Taken On :\(formatDate(photo.dateTaken))")
                        .font(.subheadline)
                        .foregroundColor(.indigo)
                        .bold()
                    
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    } // body
    
    // Helper function to format the date
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

 
