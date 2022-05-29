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

    private var providers = [String: PuzzleStateProvider]()

    private func notify() {
        notifier.input(value: ())
    }

    func getProvider(_ id: String) -> PuzzleStateProvider? {
        providers[id]
    }

    var canvasSize: CGSize {
        CGSize(width: canvas.width, height: canvas.height)
    }

    var empty: Bool { canvas.root == nil }

    var root: LayerNode? { canvas.root }

    let selected = State<String?>(nil)

    var handlers: [BoxLayoutNodeHandler] {
        [
            UIViewNodeHandler(),
            UILabelNodeHandler(),
            LinearNodeHandler(),
            ZNodeHandler(),
            FlowNodeHandler(),
        ]
    }
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
        providers.removeValue(forKey: id)
        if selected.value == id {
            selected.value = nil
        }
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

    func buildBoxLayoutNode(_ node: LayerNode) -> BoxLayoutNode {
        var result: BoxLayoutNode!
        for handler in handlers {
            if let nodeResult = handler.create(with: node) {
                if let provider = providers[node.id] ?? handler.provider(with: node) {
                    result = nodeResult
                    handler.bind(provider: provider, for: nodeResult)
                    providers[node.id] = provider
                }
                break
            }
        }

        // children
        if let container = result as? BoxLayoutContainer {
            node.children.forEach { child in
                let childNode = buildBoxLayoutNode(child)
                container.addLayoutNode(childNode)
            }
        }

        return result
    }
}

extension BoxLayoutNode {
    func getRegulator() -> Regulator? { layoutMeasure as? Regulator }
    func getLinearRegulator() -> LinearRegulator? { layoutMeasure as? LinearRegulator }
    func getFlowRegulator() -> FlowRegulator? { layoutMeasure as? FlowRegulator }
    func getZRegulator() -> ZRegulator? { layoutMeasure as? ZRegulator }
}

struct BoxLayoutNodeCreateResult {
    var node: BoxLayoutNode
    var provider: PuzzleStateProvider
}

protocol BoxLayoutNodeHandler {
    func shouldHandle(_ layerNode: LayerNode) -> Bool
    func create(with layerNode: LayerNode) -> BoxLayoutNode?
    func provider(with layerNode: LayerNode) -> PuzzleStateProvider?
    func bind(provider: PuzzleStateProvider, for node: BoxLayoutNode)
}

extension BoxLayoutNodeHandler {
    func bind(provider: PuzzleStateProvider, for node: BoxLayoutNode) {
        if let node = node as? (BoxLayoutNode & AutoDisposable) {
            node.bindBuiltinProvider(provider)
        }
    }
}
