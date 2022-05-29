//
//  State.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Puyopuyo

protocol IPuzzleState {}

class PuzzleState<T>: IPuzzleState {
    init(title: String, value: T) {
        self.title = title
        state.value = value
    }

    let title: String
    let state = State<T>.unstable()
}

protocol PuzzleStateProvider {
    var states: [IPuzzleState] { get }
}

class BasePuzzleStateProvider: PuzzleStateProvider {
    let activated = PuzzleState(title: "Activated", value: true)
    let flowEnding = PuzzleState(title: "FlowEnding", value: false)
    let margin = PuzzleState(title: "Margin", value: UIEdgeInsets.zero)
    let alignment = PuzzleState(title: "Alignment", value: Alignment.none)
    let visibility = PuzzleState(title: "Visibility", value: Visibility.visible)
    let width = PuzzleState(title: "Width", value: SizeDescription.wrap)
    let height = PuzzleState(title: "Height", value: SizeDescription.wrap)

    var states: [IPuzzleState] {
        [
            activated,
            flowEnding,
            margin,
            alignment,
            width,
            height,
            visibility,
        ]
    }
}

class BoxPuzzleStateProvider: BasePuzzleStateProvider {
    let padding = PuzzleState(title: "Padding", value: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    let justifyContent = PuzzleState(title: "JustifyContent", value: Alignment.none)
    override var states: [IPuzzleState] {
        super.states + [
            padding, justifyContent,
        ]
    }
}

class ZPuzzleStateProvider: BoxPuzzleStateProvider {}

class LinearPuzzleStateProvider: BoxPuzzleStateProvider {
    let direction = PuzzleState(title: "Direction", value: Direction.horizontal)
    let format = PuzzleState(title: "Format", value: Format.leading)
    let reverse = PuzzleState(title: "Reverse", value: false)
    let space = PuzzleState(title: "Space", value: CGFloat(0))

    override var states: [IPuzzleState] {
        super.states + [direction, format, reverse, space]
    }
}

class FlowPuzzleStateProvider: LinearPuzzleStateProvider {
    let runFormat = PuzzleState(title: "RunFormat", value: Format.leading)
    let arrange = PuzzleState(title: "Arrange", value: 0)
    let itemSpace = PuzzleState(title: "ItemSpace", value: CGFloat(0))
    let runSpace = PuzzleState(title: "RunSpace", value: CGFloat(0))

    override var states: [IPuzzleState] {
        super.states + [arrange, runFormat, itemSpace, runSpace]
    }
}
