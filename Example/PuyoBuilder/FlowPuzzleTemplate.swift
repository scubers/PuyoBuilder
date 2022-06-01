//
//  LinearPuzzleTemplate.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/29.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

import Puyopuyo

class FlowBoxPuzzleTemplate: PuzzleTemplate {
    var name: String { "FlowBox" }

    var initialNode: PuzzleNode {
        .init().config { n in
            n.nodeType = .box
            n.layoutType = .flow
        }
    }

    var builderHandler: BuildPuzzleHandler { FlowBuildPuzzleHandler() }
}

class FlowGroupPuzzleTemplate: PuzzleTemplate {
    var name: String { "FlowGroup" }

    var initialNode: PuzzleNode {
        .init().config { n in
            n.nodeType = .group
            n.layoutType = .flow
        }
    }

    var builderHandler: BuildPuzzleHandler { FlowBuildPuzzleHandler() }
}

struct FlowBuildPuzzleHandler: BuildPuzzleHandler {
    func shouldHandle(_ layerNode: PuzzleNode) -> Bool {
        layerNode.concreteViewType == nil && layerNode.nodeType != .concrete && layerNode.layoutType == .flow
    }

    func create(with layerNode: PuzzleNode) -> BoxLayoutNode? {
        guard shouldHandle(layerNode) else {
            return nil
        }
        return layerNode.nodeType == .box ? FlowBox() : FlowGroup()
    }

    func provider(with layerNode: PuzzleNode) -> PuzzleStateProvider? {
        guard shouldHandle(layerNode) else {
            return nil
        }
        return FlowPuzzleStateProvider()
    }
}
