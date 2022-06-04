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
    let root = State<BuilderPuzzleItem?>(nil)

    let selected = State<BuilderPuzzleItem?>(nil)

    let canvasSize = State(CGSize(width: 200, height: 200))

    func toggleSelect(_ item: BuilderPuzzleItem) {
        if item === selected.value {
            selected.input(value: nil)
        } else {
            selected.input(value: item)
        }
    }
}

// MARK: - Structure change

extension BuilderStore {
    func repaceRoot(_ node: BuilderPuzzleItem?) {
        root.value = node
        selected.value = nil
    }

    func removeItem(_ item: BuilderPuzzleItem) {
        item.removeFromParent()
        if item === selected.value {
            selected.value = nil
        }
        if root.value === item {
            root.value = nil
        } else {
            root.resend()
        }
    }

    func append(item: BuilderPuzzleItem, for parent: BuilderPuzzleItem) {
        parent.append(child: item)
        root.resend()
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
        node.provider.bindState(to: puzzle)
        node.puzzlePiece = puzzle

        if let puzzle = puzzle as? UIView {
            puzzle.attach()
                .userInteractionEnabled(true)
                .borderWidth(1)
                .borderColor(selected.map { $0 === node }.map {
                    $0 ? UIColor.systemPink : .clear
                })
                .onTap(to: self) { [weak node] this, _ in
                    if let node = node {
                        this.toggleSelect(node)
                    }
                }
        }

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

// MARK: - Export json

extension BuilderStore {
    func exportJson(prettyPrinted: Bool) -> String? {
        var dict = [String: Any]()
        dict["width"] = canvasSize.value.width
        dict["height"] = canvasSize.value.height
        if let root = root.value?.serialize() {
            dict["root"] = root
        }
        return Helper.toJson(dict, prettyPrinted: prettyPrinted)
    }

    func buildWithJson(_ json: String?) {
        guard let value = Helper.fromJson(json) else {
            repaceRoot(nil)
            return
        }
        let width = (value["width"] as? CGFloat) ?? 200
        let height = (value["height"] as? CGFloat) ?? 200
        canvasSize.value = .init(width: width, height: height)

        if let root = value["root"] as? [String: Any], let item = BuilderPuzzleItem.deserialize(root) {
            repaceRoot(item)
        }
    }
}
