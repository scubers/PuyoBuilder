//
//  UIViewConcreteNodeHandler.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/29.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Puyopuyo
import UIKit

struct UIViewNodeHandler: BoxLayoutNodeHandler {
    func shouldHandle(_ layerNode: LayerNode) -> Bool {
        layerNode.concreteViewType == "UIView"
    }

    func create(with layerNode: LayerNode) -> BoxLayoutNode? {
        guard layerNode.concreteViewType == "uiview" else {
            return nil
        }
        return UIView()
    }

    func provider(with layerNode: LayerNode) -> PuzzleStateProvider? {
        BasePuzzleStateProvider()
    }
}
