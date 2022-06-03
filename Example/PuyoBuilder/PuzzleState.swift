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

class PuzzleState<T>: IPuzzleState, Outputing, Inputing, SpecificValueable {
    init(title: String, value: T) {
        self.title = title
        state.value = value
    }

    let title: String
    let state = State<T>.unstable()

    func outputing(_ block: @escaping (T) -> Void) -> Disposer {
        state.outputing(block)
    }

    func input(value: T) {
        state.input(value: value)
    }

    var specificValue: T {
        get { state.value }
        set { state.value = newValue }
    }
}

protocol PuzzleStateProvider {
    var states: [IPuzzleState] { get }
    func bind(node: PuzzleNode)
    func export() -> PuzzleNode
}

class BasePuzzleStateProvider: PuzzleStateProvider {
    lazy var activated = PuzzleState(title: "Activated", value: defaultMeasure.activated)
    lazy var flowEnding = PuzzleState(title: "FlowEnding", value: defaultMeasure.flowEnding)
    lazy var margin = PuzzleState(title: "Margin", value: defaultMeasure.margin)
    lazy var alignment = PuzzleState(title: "Alignment", value: defaultMeasure.alignment)
    lazy var visibility = PuzzleState(title: "Visibility", value: Visibility.visible)
    lazy var width = PuzzleState(title: "Width", value: defaultMeasure.size.width)
    lazy var height = PuzzleState(title: "Height", value: defaultMeasure.size.height)

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
        if let v = node.activated { activated.state.value = v }
        if let v = node.flowEnding { flowEnding.state.value = v }
        if let v = node.margin?.getInsets() { margin.state.value = v }
        if let v = node.alignment?.getAlignment() { alignment.state.value = v }
        if let v = node.visibility?.getVisibility() { visibility.state.value = v }
        if let v = node.width?.getSizeDescription() { width.state.value = v }
        if let v = node.height?.getSizeDescription() { height.state.value = v }
    }

    func export() -> PuzzleNode {
        let node = PuzzleNode()
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

    lazy var defaultMeasure: Measure = getDefaultMeasure()

    func getDefaultMeasure() -> Measure {
        return Measure(delegate: nil, sizeDelegate: nil, childrenDelegate: nil)
    }
}

class BoxPuzzleStateProvider: BasePuzzleStateProvider {
    lazy var padding = PuzzleState(title: "Padding", value: (defaultMeasure as! Regulator).padding)
    lazy var justifyContent = PuzzleState(title: "JustifyContent", value: (defaultMeasure as! Regulator).justifyContent)
    override var states: [IPuzzleState] {
        super.states + [
            padding, justifyContent,
        ]
    }

    override func bind(node: PuzzleNode) {
        super.bind(node: node)
        if let v = node.padding?.getInsets() { padding.state.value = v }
        if let v = node.justifyContent?.getAlignment() { justifyContent.state.value = v }
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
    lazy var direction = PuzzleState(title: "Direction", value: (defaultMeasure as! LinearRegulator).direction)
    lazy var format = PuzzleState(title: "Format", value: (defaultMeasure as! LinearRegulator).format)
    lazy var reverse = PuzzleState(title: "Reverse", value: (defaultMeasure as! LinearRegulator).reverse)
    lazy var space = PuzzleState(title: "Space", value: (defaultMeasure as! LinearRegulator).space)

    override var states: [IPuzzleState] {
        super.states + [direction, format, reverse, space]
    }

    override func bind(node: PuzzleNode) {
        super.bind(node: node)
        if let v = node.direction?.getDirection() { direction.state.value = v }
        if let v = node.format?.getFormat() { format.state.value = v }
        if let v = node.reverse { reverse.state.value = v }
        if let v = node.space { space.state.value = v }
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
    lazy var runFormat = PuzzleState(title: "RunFormat", value: (defaultMeasure as! FlowRegulator).runFormat)
    lazy var arrange = PuzzleState(title: "Arrange", value: (defaultMeasure as! FlowRegulator).arrange)
    lazy var itemSpace = PuzzleState(title: "ItemSpace", value: (defaultMeasure as! FlowRegulator).itemSpace)
    lazy var runSpace = PuzzleState(title: "RunSpace", value: (defaultMeasure as! FlowRegulator).runSpace)

    override var states: [IPuzzleState] {
        super.states + [arrange, runFormat, itemSpace, runSpace]
    }

    override func bind(node: PuzzleNode) {
        super.bind(node: node)
        if let v = node.runForamt?.getFormat() { runFormat.state.value = v }
        if let v = node.arrange { arrange.state.value = v }
        if let v = node.itemSpace { itemSpace.state.value = v }
        if let v = node.runSpace { runSpace.state.value = v }
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
