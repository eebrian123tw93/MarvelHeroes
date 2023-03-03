//
//  DictionaryExtension.swift
//  MarvelHeroes
//
//  Created by 呂紹瑜 on 2023/3/3.
//
import Foundation

extension Dictionary where Key == String, Value: Any {

    func dencode<T: Decodable>(_ type: T.Type) throws -> T {
        let dictionary = self
        do {
            let decoder = JSONDecoder()
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            let model = try decoder.decode(type, from: data)
            return model
        } catch {
            throw CustomError.decodeError
        }
    }

}

