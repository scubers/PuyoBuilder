//
//  UILabelNodeHandler.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/29.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Puyopuyo

struct UILabelNodeHandler: BoxLayoutNodeHandler {
    func shouldHandle(_ layerNode: LayerNode) -> Bool {
        layerNode.concreteViewType == "UILabel"
    }

    func create(with layerNode: LayerNode) -> BoxLayoutNode? {
        guard shouldHandle(layerNode) else {
            return nil
        }

        let view = UILabel()
        view.text = "Demo"
        return view
    }

    func provider(with layerNode: LayerNode) -> PuzzleStateProvider? {
        BasePuzzleStateProvider()
    }
}
