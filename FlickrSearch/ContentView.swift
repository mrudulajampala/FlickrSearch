//
//  ContentView.swift
//  FlickrSearch
//
//  Created by Mrudula on 12/6/24.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = FlickrViewModel()
    
    let columns = [
        GridItem(.adaptive(minimum: 108), spacing: 1),
        GridItem(.adaptive(minimum: 108), spacing: 1),
        GridItem(.adaptive(minimum: 108), spacing: 1)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.1)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 1) {
                        ForEach(viewModel.photos) { photo in
                            NavigationLink(destination: PhotoDetailView(photo: photo)) {
                                PhotoGridView(photo: photo)
                            }
                        }
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.1))
                }
            }
            .navigationTitle("Flickr Photos")
            .searchable(
                text: .init(
                    get: { viewModel.searchText },
                    set: { viewModel.updateSearchText($0) }
                ),
                prompt: "Search photos"
                
            )
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await viewModel.refreshPhotos()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
        .task {
            await viewModel.fetchPhotos()
        }
    }
}

#Preview {
    ContentView()
}
