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
    var layerNode: PuzzleNode
}

class NodeSelectVC: UIViewController {
    private let isRoot: Bool

    private let onResult: (PuzzleNode) -> Void

    init(isRoot: Bool, onResult: @escaping (PuzzleNode) -> Void = { _ in }) {
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

        let list = PuzzleManager.shared.templates
            .map { template in
                InitNodeModel(title: template.name, layerNode: template.initialNode)
            }
            .filter { model in
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
