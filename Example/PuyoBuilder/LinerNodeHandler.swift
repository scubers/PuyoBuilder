//
//  LinerBoxNodeHandler.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/29.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Puyopuyo

struct LinearNodeHandler: BoxLayoutNodeHandler {
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
