//
//  Coder.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 4/12/21.
//

import Foundation

enum NetworkError: Error {
    case unknown
    case encodingError
}

struct Coder {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        return dateFormatter
    }()

    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return decoder
    }()

    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        encoder.keyEncodingStrategy = .convertToSnakeCase

        return encoder
    }()

    // MARK: - Helper Methods

    static func encode<T>(_ value: T) throws -> Data where T: Encodable {
        return try encoder.encode(value)
    }

    static func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        return try decoder.decode(type, from: data)
    }

    static func decode<T>(_ type: T.Type, from json: JSON) throws -> T where T: Decodable {
        guard let data = json.toJSONData() else {
            throw NetworkError.encodingError
        }
        return try decoder.decode(type, from: data)
    }

    static func objectFromJSONFile<T: Decodable>(named name: String) -> T? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let object = try decode(T.self, from: data)

            return object
        } catch {
            return nil
        }
    }
}
