//
//  ApiError.swift
//  NMSF
//
//  Created by Matt Stanford on 5/21/21.
//

import Foundation

enum ApiError: CustomError {
    case httpError(code: Int)
    case decodingError
}

extension ApiError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .httpError(let code):
            return NSLocalizedString(String(format: "An unknown error occurred (%@)", code.description), comment: "")
        case .decodingError:
            return NSLocalizedString("JSON Decoding error!", comment: "")
        }
    }
}
