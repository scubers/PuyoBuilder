//
//  CanvasPanel.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Puyopuyo

class CanvasPanel: ZBox {
    let store: BuilderStore
    init(store: BuilderStore) {
        self.store = store
        super.init(frame: .zero)

        store.onChanged.debounce(interval: 0.1).safeBind(to: self) { this, store in
            this.layoutChildren.forEach { $0.removeFromSuperBox() }
            this.subviews.forEach { $0.removeFromSuperview() }

            this.attach {
                CanvasView(store: store).attach($0)
                    .alignment(.center)
                    .animator(Animators.default)
            }
        }

        attach().justifyContent(.center)
    }

    @available(*, unavailable)
    required init?(coder argument: NSCoder) {
        fatalError()
    }
}
