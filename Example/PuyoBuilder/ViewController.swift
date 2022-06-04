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

        view.backgroundColor = .systemGroupedBackground

        ZBox().attach(view) {
            HBox().attach($0) {
                LayerPanel(store: store).attach($0)
                    .size(240, .fill)

                CanvasPanel(store: store).attach($0)
                    .size(.fill, .fill)

                PropsPanel(store: store).attach($0)
                    .size(240, .fill)
            }
            .size(.fill, .fill)
        }
        .size(.fill, .fill)

        store.repaceRoot(store.buildWithJson(Helper.defaultViewJson))
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
}
