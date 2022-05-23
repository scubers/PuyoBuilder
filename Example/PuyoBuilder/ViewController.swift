//
//  ViewController.swift
//  PuyoBuilder
//
//  Created by Jrwong on 05/22/2022.
//  Copyright (c) 2022 Jrwong. All rights reserved.
//

import Puyopuyo
import UIKit

class ViewController: UIViewController {
    let store = BuilderStore()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        HBox().attach(view) {
            LayerPanel(store: store).attach($0)
                .size(240, .fill)

            CanvasPanel(store: store).attach($0)
                .size(.fill, .fill)

            PropsPanel(store: store).attach($0)
                .size(240, .fill)
        }
        .padding(view.py_safeArea())
        .size(.fill, .fill)

        let root = LayerNode()
        root.layoutType = .flow
        root.nodeType = .box

        store.replaceRoot(root)

        let label1 = LayerNode()
        label1.nodeType = .concrete

        let label2 = LayerNode()
        label2.nodeType = .concrete

        store.appendNode(label1, id: root.id)
        store.appendNode(label2, id: root.id)
    }
}
