//
//  BuilderStore.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Puyopuyo

class BuilderStore: ChangeNotifier {
    var changeNotifier: Outputs<Void> { notifier.asOutput() }

    private let notifier = SimpleIO<Void>()

    private var canvas: LayerCanvas = .init()

    private var states = [String: LayerNodeState]()

    private func notify() {
        notifier.input(value: ())
    }

    func getState(_ id: String) -> LayerNodeState {
        if let state = states[id] {
            return state
        } else {
            let state = LayerNodeState()
            states[id] = state
            return state
        }
    }

    var canvasSize: CGSize {
        CGSize(width: canvas.width, height: canvas.height)
    }

    var empty: Bool { canvas.root == nil }

    var root: LayerNode? { canvas.root }

    let selected = State<String?>(nil)
}

// MARK: - Structure change

extension BuilderStore {
    func changeCanvasSize(_ size: CGSize) {
        canvas.width = size.width
        canvas.height = size.height
        notify()
    }

    func replaceRoot(_ root: LayerNode?) {
        canvas.repaceRoot(root)
        notify()
    }

    func removeNode(_ id: String) {
        canvas.removeNode(id)
        states.removeValue(forKey: id)
        notify()
    }

    func appendNode(_ node: LayerNode, id: String) {
        canvas.appendNode(node, for: id)
        notify()
    }

    func findNode(by id: String) -> LayerNode? {
        canvas.findNode(by: id)?.target
    }
}

// MARK: - Builder generator

extension BuilderStore {
    func buildRoot() -> BoxLayoutNode? {
        if let root = canvas.root {
            return buildBoxLayoutNode(root)
        }
        return nil
    }

    func buildBoxLayoutNode(_ node: LayerNode) -> BoxLayoutNode & AutoDisposable {
        var result: BoxLayoutNode & AutoDisposable
        switch (node.nodeType, node.layoutType) {
        case (.concrete, _):
            result = UILabel().attach().text("demo").view
        case (.box, .linear): result = LinearBox()
        case (.box, .flow): result = FlowBox()
        case (.box, .z): result = ZBox()

        case (.group, .linear): result = LinearGroup()
        case (.group, .flow): result = FlowGroup()
        case (.group, .z): result = ZGroup()
        }
        bindState(node, boxLayoutNode: result)

        // children
        if let container = result as? BoxLayoutContainer {
            node.children.forEach { child in
                let childNode = buildBoxLayoutNode(child)
                container.addLayoutNode(childNode)
            }
        }

        return result
    }

    func bindState(_ node: LayerNode, boxLayoutNode: BoxLayoutNode & AutoDisposable) {
        let state = getState(node.id)

        func _bind<V>(_ output: Outputs<V>, action: @escaping (BoxLayoutNode, V) -> Void) {
            boxLayoutNode.addDisposer(output.outputing { [weak boxLayoutNode] v in
                if let boxLayoutNode = boxLayoutNode {
                    action(boxLayoutNode, v)
                }
            }, for: nil)
        }

        node.availableStateTypes.forEach {
            switch $0 {
            case .activated:
                _bind(state.activated.state.asOutput()) { (node: BoxLayoutNode, v) in node.layoutMeasure.activated = v }
            case .flowEnding:
                _bind(state.flowEnding.state.asOutput()) { (node: BoxLayoutNode, v) in node.layoutMeasure.flowEnding = v }
            case .margin:
                _bind(state.margin.state.asOutput()) { (node: BoxLayoutNode, v) in node.layoutMeasure.margin = v }
            case .alignment:
                _bind(state.alignment.state.asOutput()) { (node: BoxLayoutNode, v) in node.layoutMeasure.alignment = v }
            case .width:
                _bind(state.width.state.asOutput()) { (node: BoxLayoutNode, v) in node.layoutMeasure.size.width = v }
            case .height:
                _bind(state.height.state.asOutput()) { (node: BoxLayoutNode, v) in node.layoutMeasure.size.height = v }
            case .visibility:
                _bind(state.visibility.state.asOutput()) { (node: BoxLayoutNode, v) in node.layoutVisibility = v }
            case .justifyContent:
                _bind(state.justifyContent.state.asOutput()) { $0.getRegulator()?.justifyContent = $1 }
            case .padding:
                _bind(state.padding.state.asOutput()) { $0.getRegulator()?.padding = $1 }
            case .direction:
                _bind(state.direction.state.asOutput()) { $0.getLinearRegulator()?.direction = $1 }
            case .reverse:
                _bind(state.reverse.state.asOutput()) { $0.getLinearRegulator()?.reverse = $1 }
            case .space:
                _bind(state.space.state.asOutput()) { $0.getLinearRegulator()?.space = $1 }
            case .format:
                _bind(state.format.state.asOutput()) { $0.getLinearRegulator()?.format = $1 }
            case .arrange:
                _bind(state.arrange.state.asOutput()) { $0.getFlowRegulator()?.arrange = $1 }
            case .itemSpace:
                _bind(state.itemSpace.state.asOutput()) { $0.getFlowRegulator()?.itemSpace = $1 }
            case .runSpace:
                _bind(state.runSpace.state.asOutput()) { $0.getFlowRegulator()?.runSpace = $1 }
            }
        }
    }
}

extension BoxLayoutNode {
    func getRegulator() -> Regulator? { layoutMeasure as? Regulator }
    func getLinearRegulator() -> LinearRegulator? { layoutMeasure as? LinearRegulator }
    func getFlowRegulator() -> FlowRegulator? { layoutMeasure as? FlowRegulator }
    func getZRegulator() -> ZRegulator? { layoutMeasure as? ZRegulator }
}
