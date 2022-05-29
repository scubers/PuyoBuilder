//
//  UIViewPuzzleTemplate.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/29.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Puyopuyo

class UIViewPuzzleTemplate: PuzzleTemplate {
    var name: String { "UIView" }

    var initialNode: LayerNode {
        .init().config { n in
            n.nodeType = .concrete
            n.concreteViewType = "UIView"
        }
    }

    var builderHandler: BuildPuzzleHandler { UIViewBuildPuzzleHandler() }
}

struct UIViewBuildPuzzleHandler: BuildPuzzleHandler {
    func shouldHandle(_ layerNode: LayerNode) -> Bool {
        layerNode.concreteViewType == "UIView"
    }

    func create(with layerNode: LayerNode) -> BoxLayoutNode? {
        guard layerNode.concreteViewType == "UIView" else {
            return nil
        }
        return UIView()
    }

    func provider(with layerNode: LayerNode) -> PuzzleStateProvider? {
        BasePuzzleStateProvider()
    }
}
