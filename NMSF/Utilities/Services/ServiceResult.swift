//
//  Result.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 4/12/21.
//

import Foundation
struct Empty: Decodable {}

enum ServiceResult<T> {
    case success(T)
    case error(Error)
}

enum PaginatedResult<T> {
    case success(PaginatedData<T>)
    case error(Error)
}

struct PaginatedData<T> {
    let data: [T]
    let offset: Int
    let pageSize: Int
    let totalCount: Int
}
