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

    var width: CGFloat = 250
    var height: CGFloat = 250

    var root: LayerNode?

   
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

    func config(_ action: (LayerNode) -> Void) -> LayerNode {
        action(self)
        return self
    }

    var id = UUID().description

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
