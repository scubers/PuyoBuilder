//
//  Helper.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

struct Helper {
    static func randomColor() -> UIColor {
        let red = CGFloat(arc4random()%256) / 255.0
        let green = CGFloat(arc4random()%256) / 255.0
        let blue = CGFloat(arc4random()%256) / 255.0
        let c = UIColor(red: red, green: green, blue: blue, alpha: 0.7)
        return c
    }
}
