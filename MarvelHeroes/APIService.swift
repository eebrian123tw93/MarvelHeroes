//
//  APIService.swift
//  MarvelHeroes
//
//  Created by 呂紹瑜 on 2023/3/3.
//

import Foundation
import Combine
import CryptoKit
//2e094a4ba352e75d82790199f96df05d
//a71741b0b81d4d24d36925c3c6bccd4843887db7
class ViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let apiService: APIService!
    init() {
        apiService = APIService()
        apiService.getCaracters()
            .sink(receiveCompletion: { error in
            print(error)
            print(type(of: error))
        }, receiveValue: { pagingData in
            print(pagingData.results.count)
        }).store(in: &cancellables)
    }
    
    
    
}
class APIService {
    
    func request(urlString: String) -> AnyPublisher<JsonResultModel, Error> {
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .handleEvents(receiveOutput: { data in
                var responseDataString = ""
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                    let dataPretty = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                    let dataString = String(data: dataPretty, encoding: .utf8) {
                    responseDataString = dataString
                } else if let dataString = String(data: data, encoding: .utf8) {
                    responseDataString = dataString
                }
                print(responseDataString)
            })
            .decode(type: JsonResultModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getCaracters() -> AnyPublisher<DataPaging<Characters>, Error> {
        let ts = Date().timeIntervalSinceReferenceDate
        let publicKey = "2e094a4ba352e75d82790199f96df05d"
        let privateKey = "a71741b0b81d4d24d36925c3c6bccd4843887db7"
        let md5InputData = "\(ts)\(privateKey)\(publicKey)".data(using: .utf8)!
        let digest = Insecure.MD5.hash(data: md5InputData)
        let hashString = digest.map {
            String(format: "%02x", $0)
        }.joined()
        
        let url = "https://gateway.marvel.com:443/v1/public/characters?ts=\(ts)&apikey=\(publicKey)&hash=\(hashString)"
        return request(urlString: url)
            .tryMap { try $0.mapTo(type: DataPaging<Characters>.self) }
            .eraseToAnyPublisher()
    }
    
    
    
}


struct Characters: Codable {
    let thumbnail: Thumbnail
    let comics, series: Comics
    let id: Int
    let stories: Stories
    let events: Comics
    let urls: [URLElement]
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
    let type: ItemType
}

enum ItemType: String, Codable {
    case cover = "cover"
    case empty = ""
    case interiorStory = "interiorStory"
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: Extension

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

enum Extension: String, Codable {
    case gif = "gif"
    case jpg = "jpg"
}

// MARK: - URLElement
struct URLElement: Codable {
    let type: URLType
    let url: String
}

enum URLType: String, Codable {
    case comiclink = "comiclink"
    case detail = "detail"
    case wiki = "wiki"
}
