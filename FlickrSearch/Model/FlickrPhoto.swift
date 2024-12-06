//
//  FlickrPhoto.swift
//  FlickrSearch
//
//  Created by Mrudula on 12/6/24.
//

import Foundation

struct FlickrFeedResult: Codable {
    let items: [FlickrPhoto]
}

struct FlickrPhoto: Codable, Identifiable {
    let title: String
    let link: String
    let media: Media
    let dateTaken: Date
    let description: String
    let published: Date
    let author: String
    let tags: String
    
    // Computed property for ID
    var id: String { link }
    
    enum CodingKeys: String, CodingKey {
        case title, link, media
        case dateTaken = "date_taken"
        case description, published, author, tags
    }
    init(title: String, link: String, media: Media, dateTaken: Date, description: String, published: Date, author: String, tags: String) {
        self.title = title
        self.link = link
        self.media = media
        self.dateTaken = dateTaken
        self.description = description
        self.published = published
        self.author = author
        self.tags = tags
        
    }
}

struct Media: Codable {
    let m: String
    
    var originalURL: String {
        m.replacingOccurrences(of: "_m.", with: ".")
    }
}
