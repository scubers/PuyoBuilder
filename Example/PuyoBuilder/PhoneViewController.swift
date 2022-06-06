//
//  PhoneViewController.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/6/5.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Puyopuyo
import UIKit

class PhoneViewController: UIViewController {
    let store: BuilderStore
    init(store: BuilderStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder argument: NSCoder) {
        fatalError()
    }

    private var nav: UINavigationController!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGroupedBackground

        HBox().attach(view) {
            CanvasPanel(store: store).attach($0)
                .size(.fill, .fill)

            nav = UINavigationController(rootViewController: LayerPanelVC(store: store))

            nav.view.attach($0)
                .size(.fill, .fill)
        }
        .padding(view.py_safeArea())
        .size(.fill, .fill)

        store.replaceRoot(store.buildWithJson(Helper.defaultViewJson))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.setStatusBarOrientation(.landscapeLeft, animated: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.setStatusBarOrientation(.portrait, animated: true)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .landscape
    }
}

private class LayerPanelVC: UIViewController {
    let store: BuilderStore
    init(store: BuilderStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder argument: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        store.selected.safeBind(to: self) { this, item in
            if item != nil {
                this.navigationController?.setViewControllers([self, PropsPanelVC(store: this.store)], animated: true)
            }
        }

        ZBox().attach(view) {
            LayerPanel(store: store).attach($0)
                .size(.fill, .fill)
        }
        .padding(view.py_safeArea())
        .size(.fill, .fill)
    }
}

private class PropsPanelVC: UIViewController {
    let store: BuilderStore
    init(store: BuilderStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder argument: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ZBox().attach(view) {
            PropsPanel(store: store).attach($0)
                .size(.fill, .fill)
        }
        .padding(view.py_safeArea())
        .size(.fill, .fill)
    }

    deinit {
        store.selected.value = nil
    }
}
