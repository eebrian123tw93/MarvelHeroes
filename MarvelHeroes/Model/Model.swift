//
//  Model.swift
//  MarvelHeroes
//
//  Created by 呂紹瑜 on 2023/3/3.
//

import Foundation

struct Characters: Codable {
    let thumbnail: Thumbnail
    let comics, series: Comics
    let id: Int
    let stories: Stories
    let events: Comics
    let urls: [AboutLink]
    let resourceURI: String
    let description: String
    let modified: String
    let name: String
}

// MARK: - Comics
struct Comics: Codable {
    let returned: Int
    let collectionURI: String
    let items: [ComicsItem]
    let available: Int
}

// MARK: - ComicsItem
struct ComicsItem: Codable {
    let name: String
    let resourceURI: String
}

// MARK: - Stories
struct Stories: Codable {
    let returned: Int
    let collectionURI: String
    let items: [StoriesItem]
    let available: Int
}

// MARK: - StoriesItem
struct StoriesItem: Codable {
    let name: String
    let resourceURI: String
//    let type: ItemType
}

//enum ItemType: String, Codable {
//    case cover = "cover"
//    case empty = ""
//    case interiorStory = "interiorStory"
//}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: String
    
    var url: URL? {
      URL(string:  "\(path.replacingOccurrences(of: "http://", with: "https://")).\(thumbnailExtension)")
    }

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

// MARK: - AboutLink
struct AboutLink: Codable {
    let type: URLType
    let url: String
}

enum URLType: String, Codable {
    case comiclink = "comiclink"
    case detail = "detail"
    case wiki = "wiki"
}
