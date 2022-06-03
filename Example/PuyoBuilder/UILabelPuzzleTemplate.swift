//
//  UIViewPuzzleTemplate.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/29.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Puyopuyo

class UILabelPuzzleTemplate: PuzzleTemplate {
    var templateId: String { "template.uilabel" }

    var name: String { "UILabel" }

    var builderHandler: BuildPuzzleHandler { UILabelBuildPuzzleHandler() }
}

struct UILabelBuildPuzzleHandler: BuildPuzzleHandler {
    func createPuzzle() -> PuzzlePiece {
        UILabel()
    }

    func createState() -> PuzzleStateProvider {
        UILabelPuzzleStateProvider()
    }
}

class UILabelPuzzleStateModel: BasePuzzleStateModel {
    var text: String?
}

class UILabelPuzzleStateProvider: BasePuzzleStateProvider {
    let text = PuzzleState(title: "Text", value: "Demo")

    override var states: [IPuzzleState] {
        [text] + super.states
    }

    override func bindState(to puzzle: PuzzlePiece) {
        super.bindState(to: puzzle)
        if let puzzle = puzzle as? UILabel {
            puzzle.attach()
                .text(text)
        }
    }

    override func resume(_ param: [String: Any]?) {
        super.resume(param)

        if let node = UILabelPuzzleStateModel.from(param) {
            text.state.value = node.text ?? ""
        }
    }

    override func serialize() -> [String: Any]? {
        let node = UILabelPuzzleStateModel.from(super.serialize()) ?? UILabelPuzzleStateModel()
        node.text = text.specificValue
        return node.toDict()
    }
}
