//
//  BuilderStore.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Puyopuyo

class BuilderStore {
    private var providers = [String: PuzzleStateProvider]()

    func getProvider(_ id: String) -> PuzzleStateProvider? {
        providers[id]
    }

    let root = State<LayerNode?>(nil)

    let selected = State<String?>(nil)

    let canvasSize = State(CGSize(width: 200, height: 200))

    var handlers: [BuildPuzzleHandler] {
        PuzzleManager.shared.templates.map(\.builderHandler)
    }
}

// MARK: - Structure change

extension BuilderStore {
    struct FindNodeResult {
        let parent: LayerNode?
        let target: LayerNode
    }

    func findNode(by id: String) -> FindNodeResult? {
        guard let root = root.value else {
            return nil
        }

        if root.id == id {
            return .init(parent: nil, target: root)
        } else {
            func findChild(for node: LayerNode, id: String) -> FindNodeResult? {
                if let index = node.children.firstIndex(where: { $0.id == id }) {
                    return .init(parent: node, target: node.children[index])
                } else {
                    for child in node.children {
                        if let target = findChild(for: child, id: id) {
                            return target
                        }
                    }
                    return nil
                }
            }

            return findChild(for: root, id: id)
        }
    }

    func repaceRoot(_ node: LayerNode?) {
        root.value = node
    }

    func removeNode(_ id: String) -> LayerNode? {
        if root.value?.id == id {
            let ret = root.value
            root.value = nil
            return ret
        }

        guard let result = findNode(by: id) else {
            return nil
        }

        result.parent?.children.removeAll(where: { $0 === result.target })

        root.resend()

        return result.target
    }

    func appendNode(_ node: LayerNode, for id: String) {
        let ret = findNode(by: id)
        ret?.target.children.append(node)
        root.resend()
    }
}

// MARK: - Builder generator

extension BuilderStore {
    func buildRoot() -> BoxLayoutNode? {
        if let root = root.value {
            return buildBoxLayoutNode(root)
        }
        return nil
    }

    func buildBoxLayoutNode(_ node: LayerNode) -> BoxLayoutNode? {
        var result: BoxLayoutNode?
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
                if let childNode = buildBoxLayoutNode(child) {
                    container.addLayoutNode(childNode)
                }
            }
        }

        if result == nil {
            print("Unsupported node: \(node)")
        }

        if let view = result?.layoutNodeView {
            view.backgroundColor = Helper.randomColor()
        }

        return result
    }
}
