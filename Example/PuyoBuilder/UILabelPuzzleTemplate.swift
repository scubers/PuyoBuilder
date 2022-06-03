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

    var initialNode: PuzzleNode {
        .init().config { n in
            n.nodeType = .concrete
            n.concreteViewType = "UILabel"
        }
    }

    var builderHandler: BuildPuzzleHandler { UILabelBuildPuzzleHandler() }
}

struct UILabelBuildPuzzleHandler: BuildPuzzleHandler {
    func shouldHandle(_ layerNode: PuzzleNode) -> Bool {
        layerNode.concreteViewType == "UILabel"
    }

    func create(with layerNode: PuzzleNode) -> BoxLayoutNode? {
        guard shouldHandle(layerNode) else {
            return nil
        }

        return UILabel()
    }

    func provider(with layerNode: PuzzleNode) -> PuzzleStateProvider? {
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

    override func bind(node: PuzzleNode) {
        super.bind(node: node)

        if let extra: UILabelPuzzleExtra = node.getExtra() {
            text.state.value = extra.text ?? ""
        }
    }

    override func export() -> PuzzleNode {
        let node = super.export()
        node.setExtra(UILabelPuzzleExtra(text: text.specificValue))
        return node
    }
}

struct UILabelPuzzleExtra: Codable {
    var text: String?
}
