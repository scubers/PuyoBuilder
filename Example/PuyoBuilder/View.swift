//
//  View.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Puyopuyo
import UIKit

class CanvasView: ZBox {
    let store: BuilderStore

    init(store: BuilderStore) {
        self.store = store

        super.init(frame: .zero)

        buildCanvas()

        store.onChanged.binder.canvasSize.distinct().safeBind(to: self) { this, v in
            this.layoutMeasure.size = Size(width: .fix(v.width), height: .fix(v.height))
        }
        
        attach().backgroundColor(.secondarySystemBackground)
            .size(store.canvasSize.width, store.canvasSize.height)
            .animator(CanvasAnimator())
        
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func buildCanvas() {
        if let node = store.buildRoot(), let view = node.layoutNodeView {
            addSubview(view)
        }
    }
}
