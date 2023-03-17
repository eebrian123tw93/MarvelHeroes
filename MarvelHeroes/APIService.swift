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
    
    func getCharacters(offset: Int = 0) -> AnyPublisher<DataPaging<Characters>, Error> {
        let ts = Date().timeIntervalSinceReferenceDate
        let publicKey = ""
        let privateKey = ""
        let md5InputData = "\(ts)\(privateKey)\(publicKey)".data(using: .utf8)!
        let digest = Insecure.MD5.hash(data: md5InputData)
        let hashString = digest.map {
            String(format: "%02x", $0)
        }.joined()
        
        let url = "https://gateway.marvel.com:443/v1/public/characters?ts=\(ts)&apikey=\(publicKey)&hash=\(hashString)&offset=\(offset)"
        return request(urlString: url)
            .tryMap { try $0.mapTo(type: DataPaging<Characters>.self) }
            .eraseToAnyPublisher()
    }
    
    
    
}
