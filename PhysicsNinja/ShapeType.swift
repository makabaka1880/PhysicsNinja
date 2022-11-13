//
//  ShapeType.swift
//  GeometryFighter
//
//  Created by SeanLi on 2022/11/13.
//

import Foundation

enum ShapeType: Int {
    case box        = 0
    case sphere     = 1
    case pyramid    = 2
    case torus      = 3
    case capsule    = 4
    case cylinder   = 5
    case cone       = 6
    case tube       = 7
    
    static var random: Self {
        let ran: Int = .random(in: 0...7)
        return .init(rawValue: ran)!
    }
}


extension BinaryInteger {
    static func random() -> Self {
        return self.init(arc4random())
    }
    static func random<T>(range: ClosedRange<T>) -> T where T: BinaryInteger {
        let upper = T.init(range.upperBound)
        let lower = T.init(range.lowerBound)
        let random = T.init(
            arc4random_uniform(
                UInt32(
                    upper - lower
                )
            ) / UInt32.max
        ) + lower
        return random
    }
}
