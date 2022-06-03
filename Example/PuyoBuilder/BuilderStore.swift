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

    let root = State<BuilderPuzzleItem?>(nil)

    let selected = State<String?>(nil)

    let canvasSize = State(CGSize(width: 200, height: 200))

    func toggleSelect(_ id: String?) {
        if id == selected.value {
            selected.input(value: nil)
        } else {
            selected.input(value: id)
        }
    }
}

// MARK: - Structure change

extension BuilderStore {
    struct FindNodeResult {
        let parent: BuilderPuzzleItem?
        let target: BuilderPuzzleItem
    }

    func findNode(by id: String) -> FindNodeResult? {
        guard let root = root.value else {
            return nil
        }

        if root.id == id {
            return .init(parent: nil, target: root)
        } else {
            func findChild(for node: BuilderPuzzleItem, id: String) -> FindNodeResult? {
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

    func repaceRoot(_ node: BuilderPuzzleItem?) {
        root.value = node
        selected.value = nil
    }

    func removeNode(_ id: String) -> BuilderPuzzleItem? {
        if root.value?.id == id {
            let ret = root.value
            repaceRoot(nil)
            return ret
        }

        guard let result = findNode(by: id) else {
            return nil
        }

        result.parent?.children.removeAll(where: { $0 === result.target })

        root.resend()

        if selected.value == result.target.id {
            selected.value = nil
        }

        return result.target
    }

    func appendNode(_ node: BuilderPuzzleItem, for id: String) {
        let ret = findNode(by: id)
        ret?.target.children.append(node)
        root.resend()
    }
}

// MARK: - Export json

extension BuilderStore {
    func exportJson(prettyPrinted: Bool) -> String? {
        let canvas = PuzzleCanvas()
        canvas.width = canvasSize.value.width
        canvas.height = canvasSize.value.height
        var dict = canvas.toDict() ?? [:]
//        canvas.root = root.value?.copy { old in
//            let new = self.getProvider(old.id)?.export() ?? old
//            new.id = old.id
//            new.layoutType = old.layoutType
//            new.concreteViewType = old.concreteViewType
//            new.nodeType = old.nodeType
//
//            return new
//        }
//        return canvas.encodeToJson(pretty: prettyPrinted)
        return nil
    }

    func buildWithJson(_ json: String?) {f
//        guard let value = PuzzleCanvas.from(json: json) else {
//            repaceRoot(nil)
//            return
//        }
//        canvasSize.value = .init(width: value.width, height: value.height)
//        repaceRoot(value.root)
    }
}

// MARK: - Builder generator

extension BuilderStore {
    func buildRoot() -> PuzzlePiece? {
        if let root = root.value {
            return buildBoxLayoutNode(root)
        }
        return nil
    }

    func buildBoxLayoutNode(_ node: BuilderPuzzleItem) -> PuzzlePiece? {
        let puzzle = node.template.builderHandler.createPuzzle()
        let stateProvider = providers[node.id] ?? node.template.builderHandler.createState()
        stateProvider.bindState(to: puzzle)
        node.puzzlePiece = puzzle
        providers[node.id] = stateProvider

        // children
        if let container = puzzle as? BoxLayoutContainer {
            node.children.forEach { child in
                if let childNode = buildBoxLayoutNode(child) {
                    container.addLayoutNode(childNode)
                }
            }
        }

        if let view = puzzle.layoutNodeView {
            view.backgroundColor = Helper.randomColor()
        }

        return puzzle
    }
}
