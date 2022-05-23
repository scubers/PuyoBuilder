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

        let this = WeakableObject<LayerPanel>(value: self)

        let selectedId = store.selected
        attach {
            RecycleBox(
                sections: [
                    ListRecycleSection(items: items.asOutput(), cell: { o, i in
                        HBox().attach {
                            UILabel().attach($0)
                                .text(o.data.node.map { node -> String in
                                    if node.nodeType == .concrete {
                                        return node.concreteViewType ?? "ConcreteView"
                                    } else {
                                        return "\(node.layoutType)"
                                    }
                                })
                                .width(.fill)

                            UIButton(type: .contactAdd).attach($0)
                                .onControlEvent(.touchUpInside, Inputs { _ in
                                    i.inContext { info in
                                        this.value?.addChild(for: info.data.node.id)
                                    }
                                })
                                .visibility(o.data.node.nodeType.map { ($0 != .concrete).py_visibleOrGone() })

                            UIButton().attach($0)
                                .image(UIImage(systemName: "trash"))
                                .userInteractionEnabled(true)
                                .onTap {
                                    i.inContext { info in
                                        this.value?.removeSelf(id: info.data.node.id)
                                    }
                                }
                        }
                        .backgroundColor(Outputs.combine(selectedId, o.data.node.id).map { v1, v2 -> UIColor in
                            if v1 == v2 {
                                return UIColor.systemBlue.withAlphaComponent(0.5)
                            }
                            return UIColor.clear
                        })
                        .padding(all: 4)
                        .padding(left: o.data.depth.map { CGFloat($0) * 8 + 4 })
                        .margin(bottom: 1)
                        .justifyContent(.center)
                        .space(4)
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
                .onTap(to: self) { this, _ in
                    this.chooseRootBox()
                }
        }
        .backgroundColor(.secondarySystemGroupedBackground)
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

    func chooseRootBox() {
        let vc = NodeSelectVC(isRoot: true) {
            self.store.replaceRoot($0)
        }
        findTopViewController(for: self)?.present(vc, animated: true)
    }

    func addChild(for id: String) {
        let vc = NodeSelectVC(isRoot: false) {
            self.store.appendNode($0, id: id)
        }
        findTopViewController(for: self)?.present(vc, animated: true)
    }

    func removeSelf(id: String) {
        store.removeNode(id)
    }
}

struct LayerPanelItem {
    var depth: Int
    var node: LayerNode
}
