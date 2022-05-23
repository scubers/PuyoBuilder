//
//  Model.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import HandyJSON

class LayerCanvas: HandyJSON {
    required init() {}

    var width: CGFloat = 300
    var height: CGFloat = 300

    var root: LayerNode?

    struct FindNodeResult {
        let parent: LayerNode?
        let target: LayerNode
    }

    func findNode(by id: String) -> FindNodeResult? {
        guard let root = root else {
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
        root = node
    }

    @discardableResult
    func removeNode(_ id: String) -> LayerNode? {
        if root?.id == id {
            let ret = root
            root = nil
            return ret
        }

        guard let result = findNode(by: id) else {
            return nil
        }

        result.parent?.children.removeAll(where: { $0 === result.target })

        return result.target
    }

    func appendNode(_ node: LayerNode, for id: String) {
        let ret = findNode(by: id)
        ret?.target.children.append(node)
    }
}

class LayerNode: HandyJSON {
    required init() {}

    enum NodeType: String, HandyJSONEnum {
        case concrete
        case box
        case group
    }

    enum LayoutType: String, HandyJSONEnum {
        case linear
        case flow
        case z
    }

    let id = UUID().description

    /// layout or normal view
    var nodeType: NodeType = .box

    var layoutType: LayoutType = .z

    var concreteViewType: String?

    ///
    /// subclassing
    var titleDescr: String {
        fatalError()
    }

    var children = [LayerNode]()

    // MARK: - Base Props

    var activated: Bool?
    var flowEnding: Bool?
    var margin: UIEdgeInsets?
    var alignment: LayerNodeAlignment?
    var width: LayerNodeSizeDesc?
    var height: LayerNodeSizeDesc?
    var visibility: LayerNodeVisibility?

    // MARK: - Regulator Props

    var justifyContent: LayerNodeAlignment?
    var padding: UIEdgeInsets?

    // MARK: - Linear Props

    var direction: LayerNodeDirection?
    var reverse: Bool?
    var space: CGFloat?
    var format: LayerNodeFormat?

    // MARK: - Flow props

    var arrange: CGFloat?
    var itemSpace: CGFloat?
    var runSpace: CGFloat?

    // MARK: Methods

    var rootable: Bool {
        nodeType == .box
    }
}

class LayerNodeSizeDesc: HandyJSON {
    required init() {}

    enum SizeType: String, HandyJSONEnum {
        case fixed
        case wrap
        case ratio
        case aspectRatio
    }

    var sizeType: SizeType = .wrap

    var fixedValue: CGFloat?
    var ratio: CGFloat?
    var add: CGFloat?
    var min: CGFloat?
    var max: CGFloat?
    var priority: CGFloat?
    var shrink: CGFloat?
    var grow: CGFloat?
    var aspectRatio: CGFloat?
}

class LayerNodeAlignment: HandyJSON {
    required init() {}
    enum AlignmentType: String, HandyJSONEnum {
        case top, left, bottom, right, horzCenter, vertCenter
    }

    var centerRatio: CGPoint?
}

enum LayerNodeDirection: String, HandyJSONEnum {
    case horizontal, vertical
}

enum LayerNodeFormat: String, HandyJSONEnum {
    case leading, center, between, round, trailing
}

enum LayerNodeVisibility: String, HandyJSONEnum {
    case visible, invisible, gone, free
}
