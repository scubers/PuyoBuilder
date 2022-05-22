//
//  LayerPanel.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Puyopuyo

class LayerPanel: ZBox {
    let store: BuilderStore
    init(store: BuilderStore) {
        self.store = store
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder argument: NSCoder) {
        fatalError()
    }

    override func buildBody() {
        let empty = store.onChanged.binder.empty.debounce(interval: 0.1)

        attach {
            RecycleBox(
                sections: [
                    ListRecycleSection(items: items.asOutput(), cell: { o, _ in
                        HBox().attach {
                            UILabel().attach($0)
                                .text(o.data.node.layoutType.map { "\($0)" })
                        }
                        .padding(all: 8, bottom: 0)
                        .margin(left: o.data.depth.map { CGFloat($0) * 8 })
                        .width(o.contentSize.width)
                    })
                ].asOutput()
            )
            .attach($0)
            .size(.fill, .fill)
            .visibility(empty.map { (!$0).py_visibleOrGone() })

            UIButton(type: .contactAdd).attach($0)
                .alignment(.center)
                .visibility(empty.map { $0.py_visibleOrGone() })
        }
    }

    var items: Outputs<[LayerPanelItem]> {
        store.onChanged.map { store in
            guard let root = store.root else {
                return []
            }
            var items = [LayerPanelItem]()
            func deep(node: LayerNode, depth: Int) {
                items.append(.init(depth: depth, node: node))
                node.children.forEach { child in
                    deep(node: child, depth: depth + 1)
                }
            }
            deep(node: root, depth: 0)
            return items
        }
    }
}

struct LayerPanelItem {
    var depth: Int
    var node: LayerNode
    var selected: Bool = false
}
