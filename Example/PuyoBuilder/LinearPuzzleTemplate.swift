//
//  LinearPuzzleTemplate.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/29.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

import Puyopuyo

class LinearBoxPuzzleTemplate: PuzzleTemplate {
    var name: String { "LinearBox" }

    var initialNode: LayerNode {
        .init().config { n in
            n.nodeType = .box
            n.layoutType = .linear
        }
    }

    var builderHandler: BuildPuzzleHandler { LinearBuildPuzzleHandler() }
}

class LinearGroupPuzzleTemplate: PuzzleTemplate {
    var name: String { "LinearGroup" }

    var initialNode: LayerNode {
        .init().config { n in
            n.nodeType = .group
            n.layoutType = .linear
        }
    }

    var builderHandler: BuildPuzzleHandler { LinearBuildPuzzleHandler() }
}

struct LinearBuildPuzzleHandler: BuildPuzzleHandler {
    func shouldHandle(_ layerNode: LayerNode) -> Bool {
        layerNode.concreteViewType == nil && layerNode.nodeType != .concrete && layerNode.layoutType == .linear
    }

    func create(with layerNode: LayerNode) -> BoxLayoutNode? {
        guard shouldHandle(layerNode) else {
            return nil
        }

        return layerNode.nodeType == .box ? LinearBox() : LinearGroup()
    }

    func provider(with layerNode: LayerNode) -> PuzzleStateProvider? {
        LinearPuzzleStateProvider()
    }
}
