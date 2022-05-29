//
//  FlowNodeHandler.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/29.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Puyopuyo

struct FlowNodeHandler: BoxLayoutNodeHandler {
    func shouldHandle(_ layerNode: LayerNode) -> Bool {
        layerNode.concreteViewType == nil && layerNode.nodeType != .concrete && layerNode.layoutType == .flow
    }

    func create(with layerNode: LayerNode) -> BoxLayoutNode? {
        guard shouldHandle(layerNode) else {
            return nil
        }
        return layerNode.nodeType == .box ? FlowBox() : FlowGroup()
    }

    func provider(with layerNode: LayerNode) -> PuzzleStateProvider? {
        guard shouldHandle(layerNode) else {
            return nil
        }
        return FlowPuzzleStateProvider()
    }
}
