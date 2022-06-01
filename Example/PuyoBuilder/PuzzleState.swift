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
    func bind(node: PuzzleNode)
    func export() -> PuzzleNode
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

    func bind(node: PuzzleNode) {
        activated.state.value = node.activated ?? true
        flowEnding.state.value = node.flowEnding ?? false
        margin.state.value = node.margin?.getInsets() ?? .zero
        alignment.state.value = node.alignment?.getAlignment() ?? .none
        visibility.state.value = node.visibility?.getVisibility() ?? .visible
        width.state.value = node.width?.getSizeDescription() ?? .wrap
        height.state.value = node.height?.getSizeDescription() ?? .wrap
    }

    func export() -> PuzzleNode {
        let node = PuzzleNode()
        let defaultMeasure = getDefaultMeasure()
        if activated.state.value != defaultMeasure.activated {
            node.activated = activated.state.value
        }
        if flowEnding.state.value != defaultMeasure.flowEnding {
            node.flowEnding = flowEnding.state.value
        }
        if margin.state.value != defaultMeasure.margin {
            node.margin = PuzzleInsets.from(margin.state.value)
        }
        if alignment.state.value != defaultMeasure.alignment {
            node.alignment = PuzzleAlignment.from(alignment.state.value)
        }
        if visibility.state.value != .visible {
            node.visibility = PuzzleVisibility.from(visibility.state.value)
        }
        if width.state.value != defaultMeasure.size.width {
            node.width = PuzzleSizeDesc.from(width.state.value)
        }
        if height.state.value != defaultMeasure.size.height {
            node.height = PuzzleSizeDesc.from(height.state.value)
        }
        return node
    }

    func getDefaultMeasure() -> Measure {
        return Measure(delegate: nil, sizeDelegate: nil, childrenDelegate: nil)
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

    override func bind(node: PuzzleNode) {
        super.bind(node: node)
        padding.state.value = node.padding?.getInsets() ?? .init(top: 8, left: 8, bottom: 8, right: 8)
        justifyContent.state.value = node.justifyContent?.getAlignment() ?? .none
    }

    override func export() -> PuzzleNode {
        let node = super.export()
        let defaultMeasure = getDefaultMeasure() as! Regulator
        if padding.state.value != defaultMeasure.padding {
            node.padding = PuzzleInsets.from(padding.state.value)
        }
        if justifyContent.state.value != defaultMeasure.justifyContent {
            node.justifyContent = PuzzleAlignment.from(justifyContent.state.value)
        }
        return node
    }

    override func getDefaultMeasure() -> Measure {
        return Regulator(delegate: nil, sizeDelegate: nil, childrenDelegate: nil)
    }
}

class ZPuzzleStateProvider: BoxPuzzleStateProvider {
    
    override func export() -> PuzzleNode {
        let node = super.export()
        return node
    }
    override func getDefaultMeasure() -> Measure {
        return ZRegulator(delegate: nil, sizeDelegate: nil, childrenDelegate: nil)
    }
}

class LinearPuzzleStateProvider: BoxPuzzleStateProvider {
    let direction = PuzzleState(title: "Direction", value: Direction.horizontal)
    let format = PuzzleState(title: "Format", value: Format.leading)
    let reverse = PuzzleState(title: "Reverse", value: false)
    let space = PuzzleState(title: "Space", value: CGFloat(0))

    override var states: [IPuzzleState] {
        super.states + [direction, format, reverse, space]
    }

    override func bind(node: PuzzleNode) {
        super.bind(node: node)
        direction.state.value = node.direction?.getDirection() ?? .horizontal
        format.state.value = node.format?.getFormat() ?? .leading
        reverse.state.value = node.reverse ?? false
        space.state.value = node.space ?? 0
    }

    override func export() -> PuzzleNode {
        let node = super.export()
        let defaultMeasure = getDefaultMeasure() as! LinearRegulator

        if direction.state.value != defaultMeasure.direction {
            node.direction = PuzzleDirection.from(direction.state.value)
        }

        if format.state.value != defaultMeasure.format {
            node.format = PuzzleFormat.from(format.state.value)
        }
        if reverse.state.value != defaultMeasure.reverse {
            node.reverse = reverse.state.value
        }
        if space.state.value != defaultMeasure.space {
            node.space = space.state.value
        }

        return node
    }

    override func getDefaultMeasure() -> Measure {
        return LinearRegulator(delegate: nil, sizeDelegate: nil, childrenDelegate: nil)
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

    override func bind(node: PuzzleNode) {
        super.bind(node: node)
        runFormat.state.value = node.runForamt?.getFormat() ?? .leading
        arrange.state.value = node.arrange ?? 0
        itemSpace.state.value = node.itemSpace ?? 0
        runSpace.state.value = node.runSpace ?? 0
    }

    override func export() -> PuzzleNode {
        let node = super.export()
        let defaultMeasure = getDefaultMeasure() as! FlowRegulator

        if runFormat.state.value != defaultMeasure.runFormat {
            node.runForamt = PuzzleFormat.from(runFormat.state.value)
        }
        if arrange.state.value != defaultMeasure.arrange {
            node.arrange = arrange.state.value
        }
        if itemSpace.state.value != defaultMeasure.itemSpace {
            node.itemSpace = itemSpace.state.value
        }
        if runSpace.state.value != defaultMeasure.runSpace {
            node.runSpace = runSpace.state.value
        }

        return node
    }

    override func getDefaultMeasure() -> Measure {
        return FlowRegulator(delegate: nil, sizeDelegate: nil, childrenDelegate: nil)
    }
}
