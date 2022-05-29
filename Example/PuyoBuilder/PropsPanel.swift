//
//  PropsPanel.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Puyopuyo

class PropsPanel: ZBox {
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
        let this = WeakableObject(value: self)
        attach {
            UIScrollView().attach($0) {
                VBox().attach($0) {
                    store.selected.safeBind(to: $0) { vbox, id in
                        vbox.layoutChildren.forEach { $0.removeFromSuperBox() }

                        guard let id = id, let this = this.value, let provider = this.store.getProvider(id) else {
                            return
                        }

                        for state in provider.states {
                            if let view = InspectorViewFactory().createInspect(state) {
                                view.dislplayView.attach(vbox)
                                    .width(.fill)
                            }
                        }
                    }
                }
                .size(.fill, .wrap)
                .space(1)
                .autoJudgeScroll(true)
                .backgroundColor(UIColor.systemGroupedBackground)
            }
            .set(\.showsVerticalScrollIndicator, false)
            .size(.fill, .fill)
        }
        .backgroundColor(.secondarySystemGroupedBackground)
    }
}
