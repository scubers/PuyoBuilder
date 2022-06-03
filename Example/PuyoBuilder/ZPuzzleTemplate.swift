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
    var name: String { "ZBox" }

    var initialNode: PuzzleNode {
        .init().config { n in
            n.nodeType = .box
            n.layoutType = .z
            n.padding = .init(top: 8, left: 8, bottom: 8, right: 8)
        }
    }

    var builderHandler: BuildPuzzleHandler { ZBuildPuzzleHandler() }
}

class ZGroupPuzzleTemplate: PuzzleTemplate {
    var name: String { "ZGroup" }

    var initialNode: PuzzleNode {
        .init().config { n in
            n.nodeType = .group
            n.layoutType = .z
        }
    }

    var builderHandler: BuildPuzzleHandler { ZBuildPuzzleHandler() }
}

struct ZBuildPuzzleHandler: BuildPuzzleHandler {
    func shouldHandle(_ layerNode: PuzzleNode) -> Bool {
        layerNode.concreteViewType == nil && layerNode.nodeType != .concrete && layerNode.layoutType == .z
    }

    func create(with layerNode: PuzzleNode) -> BoxLayoutNode? {
        guard shouldHandle(layerNode) else {
            return nil
        }
        return layerNode.nodeType == .box ? ZBox() : ZGroup()
    }

    func provider(with layerNode: PuzzleNode) -> PuzzleStateProvider? {
        ZPuzzleStateProvider()
    }
}
