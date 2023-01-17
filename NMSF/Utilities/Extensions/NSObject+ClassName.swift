//
//  NSObject+ClassName.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 3/30/21.
//

import Foundation

extension NSObject {
    class var className: String {
        return String(describing: self)
    }

    var className: String {
        return String(describing: type(of: self))
    }
}
