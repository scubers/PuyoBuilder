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

    var initialNode: LayerNode {
        .init().config { n in
            n.nodeType = .box
            n.layoutType = .z
        }
    }

    var builderHandler: BuildPuzzleHandler { ZBuildPuzzleHandler() }
}

class ZGroupPuzzleTemplate: PuzzleTemplate {
    var name: String { "ZGroup" }

    var initialNode: LayerNode {
        .init().config { n in
            n.nodeType = .group
            n.layoutType = .z
        }
    }

    var builderHandler: BuildPuzzleHandler { ZBuildPuzzleHandler() }
}

struct ZBuildPuzzleHandler: BuildPuzzleHandler {
    func shouldHandle(_ layerNode: LayerNode) -> Bool {
        layerNode.concreteViewType == nil && layerNode.nodeType != .concrete && layerNode.layoutType == .z
    }

    func create(with layerNode: LayerNode) -> BoxLayoutNode? {
        guard shouldHandle(layerNode) else {
            return nil
        }
        return layerNode.nodeType == .box ? ZBox() : ZGroup()
    }

    func provider(with layerNode: LayerNode) -> PuzzleStateProvider? {
        ZPuzzleStateProvider()
    }
}
