//
//  NodeSelectVC.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/24.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Puyopuyo
import UIKit

struct InitNodeModel {
    var title: String
    var layerNode: LayerNode
}

class NodeSelectVC: UIViewController {
    private let isRoot: Bool

    private let onResult: (LayerNode) -> Void

    init(isRoot: Bool, onResult: @escaping (LayerNode) -> Void = { _ in }) {
        self.isRoot = isRoot
        self.onResult = onResult
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    let state = State([InitNodeModel]())

    override func viewDidLoad() {
        super.viewDidLoad()

        var list: [InitNodeModel] = [
            .init(title: "LinearBox", layerNode: {
                let node = LayerNode()
                node.layoutType = .linear
                node.nodeType = .box
                return node
            }()),
            .init(title: "FlowBox", layerNode: {
                let node = LayerNode()
                node.layoutType = .flow
                node.nodeType = .box
                return node
            }()),
            .init(title: "ZBox", layerNode: {
                let node = LayerNode()
                node.layoutType = .z
                node.nodeType = .box
                return node
            }()),
            .init(title: "LinearGroup", layerNode: {
                let node = LayerNode()
                node.layoutType = .linear
                node.nodeType = .group
                return node
            }()),
            .init(title: "FlowGroup", layerNode: {
                let node = LayerNode()
                node.layoutType = .flow
                node.nodeType = .group
                return node
            }()),
            .init(title: "ZGroup", layerNode: {
                let node = LayerNode()
                node.layoutType = .z
                node.nodeType = .group
                return node
            }()),
            .init(title: "UILabel", layerNode: {
                let node = LayerNode()
                node.layoutType = .z
                node.nodeType = .concrete
                node.concreteViewType = "UILabel"
                return node
            }()),
        ]

        list = list.filter { model in
            !isRoot || model.layerNode.nodeType == .box
        }

        state.value = list

        let this = WeakableObject(value: self)

        ZBox().attach(view) {
            RecycleBox(
                sections: [
                    ListRecycleSection(
                        insets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16),
                        lineSpacing: 16,
                        items: state.asOutput(), cell: { o, _ in
                            ZBox().attach {
                                UILabel().attach($0)
                                    .fontSize(20, weight: .bold)
                                    .text(o.data.title)
                            }
                            .backgroundColor(.secondarySystemGroupedBackground)
                            .justifyContent(.center)
                            .width(o.contentSize.width.map { SizeDescription.fix($0 / 3 - 8) })
                            .height(.aspectRatio(3))
                        },
                        didSelect: { info in
                            let result = this.value?.onResult

                            this.value?.dismiss(animated: true, completion: {
                                result?(info.data.layerNode)
                            })
                        }
                    ),
                ].asOutput()
            )
            .attach($0)
            .size(.fill, .fill)
        }
        .size(.fill, .fill)
        .backgroundColor(.systemGroupedBackground)
    }
}
