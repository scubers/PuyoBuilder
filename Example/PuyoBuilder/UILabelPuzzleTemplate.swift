//
//  UIViewPuzzleTemplate.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/29.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Puyopuyo

class UILabelPuzzleTemplate: PuzzleTemplate {
    var name: String { "UILabel" }

    var initialNode: LayerNode {
        .init().config { n in
            n.nodeType = .concrete
            n.concreteViewType = "UILabel"
        }
    }

    var builderHandler: BuildPuzzleHandler { UILabelBuildPuzzleHandler() }
}

struct UILabelBuildPuzzleHandler: BuildPuzzleHandler {
    func shouldHandle(_ layerNode: LayerNode) -> Bool {
        layerNode.concreteViewType == "UILabel"
    }

    func create(with layerNode: LayerNode) -> BoxLayoutNode? {
        guard shouldHandle(layerNode) else {
            return nil
        }

        return UILabel()
    }

    func provider(with layerNode: LayerNode) -> PuzzleStateProvider? {
        UILabelPuzzleStateProvider()
    }

    func bind(provider: PuzzleStateProvider, for node: BoxLayoutNode) {
        _bind(provider: provider, for: node)
        if let provider = provider as? UILabelPuzzleStateProvider, let node = node as? UILabel {
            node.attach().text(provider.text.state)
        }
    }
}

class UILabelPuzzleStateProvider: BasePuzzleStateProvider {
    let text = PuzzleState(title: "Text", value: "Demo")

    override var states: [IPuzzleState] {
        [text] + super.states
    }
}
