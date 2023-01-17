//
//  CoreDataError.swift
//  NMSF
//
//  Created by Matt Stanford on 5/20/21.
//

import Foundation

enum CoreDataError: CustomError {
    case unknown
    case noIdentifier
    case noFetchRequest
    case noFinalResult
}

extension CoreDataError {
    var localizedDescription: String {
        switch self {
        case .noIdentifier:
            return NSLocalizedString("No identifier", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "")
        case .noFetchRequest, .noFinalResult:
            return NSLocalizedString("Database error", comment: "")
        }
    }
}
