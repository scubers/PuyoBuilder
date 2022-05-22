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

        let this = WeakableObject(value: self)

        let selectedId = store.selected
        attach {
            RecycleBox(
                sections: [
                    ListRecycleSection(items: items.asOutput(), cell: { o, _ in
                        HBox().attach {
                            UILabel().attach($0)
                                .text(o.data.node.layoutType.map { "\($0)" })
                        }
                        .backgroundColor(Outputs.combine(selectedId, o.data.node.id).map({ (v1, v2) -> UIColor in
                            if v1 == v2 {
                                return UIColor.systemBlue
                            }
                            return UIColor.secondarySystemBackground
                        }))
                        .padding(all: 4)
                        .margin(left: o.data.depth.map { CGFloat($0) * 8 })
                        .margin(bottom: 1)
                        .width(o.contentSize.width)
                    }, didSelect: { info in
                        if let id = this.value?.store.selected.value, id == info.data.node.id {
                            this.value?.store.selected.value = nil
                        } else {
                            this.value?.store.selected.value = info.data.node.id
                        }
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
}
