//
//  LinearPuzzleTemplate.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/29.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

import Puyopuyo

class ZBoxPuzzleTemplate: PuzzleTemplate {
    var templateId: String { "template.zbox" }

    var name: String { "ZBox" }

    var initialNode: PuzzleNode {
        .init().config { n in
            n.nodeType = .box
            n.layoutType = .z
            n.padding = .init(top: 8, left: 8, bottom: 8, right: 8)
        }
    }

    var builderHandler: BuildPuzzleHandler { ZBuildPuzzleHandler(isGroup: false) }
}

class ZGroupPuzzleTemplate: PuzzleTemplate {
    var templateId: String { "template.zgroup" }
    var name: String { "ZGroup" }

    var initialNode: PuzzleNode {
        .init().config { n in
            n.nodeType = .group
            n.layoutType = .z
        }
    }

    var builderHandler: BuildPuzzleHandler { ZBuildPuzzleHandler(isGroup: true) }
}

struct ZBuildPuzzleHandler: BuildPuzzleHandler {
    let isGroup: Bool

    func createPuzzle() -> PuzzlePiece {
        isGroup ? ZGroup() : ZBox()
    }

    func createState() -> PuzzleStateProvider {
        ZPuzzleStateProvider()
    }
}

class ZPuzzleStateProvider: BoxPuzzleStateProvider {
    override func getDefaultMeasure() -> Measure {
        return ZRegulator(delegate: nil, sizeDelegate: nil, childrenDelegate: nil)
    }
}
