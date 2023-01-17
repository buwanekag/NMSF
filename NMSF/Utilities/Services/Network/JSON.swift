//
//  JSON.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 4/12/21.
//

import Foundation

enum JSON: Equatable {
    case string(String)
    case number(Float)
    case object([String: JSON])
    case array([JSON])
    case bool(Bool)
    case null

    var rawValue: [String: Any] {
        let encoder = Coder.encoder

        do {
            let jsonData = try encoder.encode(self)
            return try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] ?? [:]
        } catch {
            return [:]
        }
    }
}

extension JSON: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case let .array(array):
            try container.encode(array)
        case let .object(object):
            try container.encode(object)
        case let .string(string):
            try container.encode(string)
        case let .number(number):
            try container.encode(number)
        case let .bool(bool):
            try container.encode(bool)
        case .null:
            try container.encodeNil()
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let object = try? container.decode([String: JSON].self) {
            self = .object(object)
        } else if let array = try? container.decode([JSON].self) {
            self = .array(array)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let number = try? container.decode(Float.self) {
            self = .number(number)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid JSON value."))
        }
    }
}

extension JSON: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .string(str):
            return str.debugDescription
        case let .number(num):
            return num.debugDescription
        case let .bool(bool):
            return bool.description
        case .null:
            return "null"
        default:
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted]
            return (try? String(data: encoder.encode(self), encoding: .utf8)) ?? "Invalid JSON value"
        }
    }
}

