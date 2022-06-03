//
//  BuilderPuzzleItem.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/6/4.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

class BuilderPuzzleItem {
    var id = UUID().description
    var title: String = ""
    var template: PuzzleTemplate
    var children: [BuilderPuzzleItem] = []
    weak var puzzlePiece: PuzzlePiece? {
        didSet {
            if let puzzlePiece = puzzlePiece {
//                let id = withUnsafePointer(to: puzzlePiece) { $0.debugDescription }
                title = "\(type(of: puzzlePiece))"
            } else {
                title = "Empty"
            }
        }
    }

    init(template: PuzzleTemplate) {
        self.template = template
    }
}
