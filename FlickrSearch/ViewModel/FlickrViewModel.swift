//
//  FlickrViewModel.swift
//  FlickrSearch
//
//  Created by Mrudula on 12/6/24.
//

import Foundation

import SwiftUI
import Combine

@Observable
final class FlickrViewModel {
    var photos: [FlickrPhoto] = []
    var searchText = ""
    var isLoading = false
    var errorMessage: String?
    
    private let baseURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
    private var cancellables = Set<AnyCancellable>()
    private let cache = NSCache<NSString, NSArray>()
    private let searchSubject = PassthroughSubject<String, Never>()
    
    init() {
        setupSearchSubscription()
    }
    
    private func setupSearchSubscription() {
        searchSubject
            .debounce(for: .milliseconds(600), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                Task { @MainActor in
                    await self?.fetchPhotos()
                }
            }
            .store(in: &cancellables)
    }
    
    func updateSearchText(_ newText: String) {
        searchText = newText
        searchSubject.send(newText)
    }
    
    @MainActor
    func fetchPhotos() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let cacheKey = NSString(string: searchText)
            if let cachedPhotos = cache.object(forKey: cacheKey) as? [FlickrPhoto] {
                photos = cachedPhotos
                isLoading = false
                return
            }
            
            var urlString = baseURL
            
            if !searchText.isEmpty {
                let tags = searchText
                    .components(separatedBy: " ")
                    .filter { !$0.isEmpty }
                    .joined(separator: ",")
                
                if let encodedTags = tags.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
               //     print ("--------------------------- \(encodedTags)")
                    urlString += "&tags=\(encodedTags)"
                }
            }
            
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }
            
            // 1. Fetch data from the Flickr API URL using URLSession
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // 2. Create a JSON decoder and configure it to parse ISO8601 dates
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            // 3. Decode the JSON data into our FlickrFeedResult model
            // This will parse the API response into a Swift object we can work with
            let result = try decoder.decode(FlickrFeedResult.self, from: data)
            photos = result.items
            cache.setObject(result.items as NSArray, forKey: cacheKey)
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
    
    @MainActor
    func refreshPhotos() async {
        clearCache()
        await fetchPhotos()
    }
    
    
}
