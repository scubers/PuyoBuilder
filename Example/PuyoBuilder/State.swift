//
//  State.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Puyopuyo

enum StateType {
    case activated
    case flowEnding
    case margin
    case alignment
    case width
    case height
    case visibility

    case justifyContent
    case padding

    case direction
    case reverse
    case space
    case format

    case arrange
    case itemSpace
    case runSpace
}

class StateDesc<Value> {
    init(title: String, type: StateType, value: Value) {
        self.state = State(value: value)
        self.title = title
        self.type = type
    }

    let state: State<Value>

    let title: String
    let type: StateType
}

class LayerNodeState {
    let activated = StateDesc(title: "Activated", type: .activated, value: true)
    let flowEnding = StateDesc(title: "FlowEnding", type: .flowEnding, value: false)
    let margin = StateDesc(title: "Margin", type: .margin, value: UIEdgeInsets.zero)
    let alignment = StateDesc(title: "Alignment", type: .alignment, value: Alignment.none)
    let width = StateDesc(title: "Width", type: .width, value: SizeDescription.wrap)
    let height = StateDesc(title: "Height", type: .height, value: SizeDescription.wrap)
    let visibility = StateDesc(title: "Visibility", type: .visibility, value: Visibility.visible)

    let justifyContent = StateDesc(title: "JustifyContent", type: .justifyContent, value: Alignment.none)
    let padding = StateDesc(title: "Padding", type: .padding, value: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    let direction = StateDesc(title: "Direction", type: .direction, value: Direction.horizontal)
    let reverse = StateDesc(title: "Reverse", type: .reverse, value: false)
    let space = StateDesc(title: "Space", type: .space, value: CGFloat(0))
    let format = StateDesc(title: "Format", type: .format, value: Format.leading)
    let arrange = StateDesc(title: "Arrange", type: .arrange, value: 0)
    let itemSpace = StateDesc(title: "ItemSpace", type: .itemSpace, value: CGFloat(0))
    let runSpace = StateDesc(title: "RunSpace", type: .runSpace, value: CGFloat(0))
}

extension LayerNode {
    var availableStateTypes: [StateType] {
        let concreteTypes = [
            StateType.activated,
            .flowEnding,
            .margin,
            .alignment,
            .width,
            .height,
            .visibility,
        ]
        let boxTypes = [
            StateType.justifyContent,
            .padding,
        ]
        let linearTypes = [
            StateType.direction,
            .reverse,
            .space,
            .format,
        ]
        let flowTypes = [
            StateType.arrange,
            .itemSpace,
            .runSpace,
        ]
        var types = [StateType]()
        switch (nodeType, layoutType) {
        case (.concrete, _):
            types = concreteTypes
        case (_, .z):
            types = concreteTypes + boxTypes
        case (_, .linear):
            types = concreteTypes + boxTypes + linearTypes
        case (_, .flow):
            types = concreteTypes + boxTypes + linearTypes + flowTypes
        }
        return types
    }
}

protocol InspectState: Inspectable {
    associatedtype StateType
    var state: State<StateType> { get }
    var title: String { get }
}

protocol Inspectable {}

class PuzzleState<T>: InspectState {
    init(title: String, value: T) {
        self.title = title
        state.value = value
    }

    let title: String
    let state = State<T>.unstable()
}

protocol PuzzleStateProvider {
    var states: [Inspectable] { get }
}

class BasePuzzleStateProvider: PuzzleStateProvider {
    let activated = PuzzleState(title: "Activated", value: true)
    let flowEnding = PuzzleState(title: "FlowEnding", value: false)
    let margin = PuzzleState(title: "Margin", value: UIEdgeInsets.zero)
    let alignment = PuzzleState(title: "Alignment", value: Alignment.none)
    let visibility = PuzzleState(title: "Margin", value: Visibility.visible)
    let width = PuzzleState(title: "Width", value: SizeDescription.wrap)
    let height = PuzzleState(title: "Height", value: SizeDescription.wrap)

    var states: [Inspectable] {
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
    override var states: [Inspectable] {
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

    override var states: [Inspectable] {
        super.states + [direction, format, reverse, space]
    }
}

class FlowPuzzleStateProvider: LinearPuzzleStateProvider {
    let runFormat = PuzzleState(title: "RunFormat", value: Format.leading)
    let arrange = PuzzleState(title: "Arrange", value: 0)
    let itemSpace = PuzzleState(title: "ItemSpace", value: CGFloat(0))
    let runSpace = PuzzleState(title: "RunSpace", value: CGFloat(0))

    override var states: [Inspectable] {
        super.states + [arrange, runFormat, itemSpace, runSpace]
    }
}
