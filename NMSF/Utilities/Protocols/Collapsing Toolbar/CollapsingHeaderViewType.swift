//
//  CollapsingHeaderViewType.swift
//  NMSF
//
//  Created by Matt Stanford on 4/23/21.
//

import UIKit

protocol CollapsingHeaderViewType {
    var needsHeightInitialization: Bool { get }
    var maxHeight: CGFloat { get }
    var minHeight: CGFloat { get }
    
    func initializeMaxHeight(containerView: CollapsingToolbarVCType)
    func changedHeight(newHeight: CGFloat)
}
