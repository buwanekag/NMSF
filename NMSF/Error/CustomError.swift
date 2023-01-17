//
//  CustomError.swift
//  NMSF
//
//  Created by Matt Stanford on 5/20/21.
//

import Foundation

protocol CustomError: LocalizedError {
    var title: String { get }
    var localizedDescription: String { get }
}

extension CustomError {
    var title: String {
        return Constants.Common.error
    }
}
