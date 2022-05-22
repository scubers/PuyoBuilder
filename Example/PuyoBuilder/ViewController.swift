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
        root.layoutType = .linear
        root.nodeType = .box

        store.replaceRoot(root)

        let label = LayerNode()
        label.nodeType = .concrete

        store.appendNode(label, id: root.id)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
