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

        attach()
            .justifyContent(.center)
            .padding(all: 20)
    }

    @available(*, unavailable)
    required init?(coder argument: NSCoder) {
        fatalError()
    }

    override func buildBody() {
        let this = WeakableObject(value: self)

        attach {
            let colorizeIsOn = State(true)

            CanvasView(store: store).attach($0) {
                colorizeIsOn.safeBind(to: $0) { view, isOn in
                    if isOn {
                        view.colorizeSubviews { Helper.randomColor() }
                    } else {
                        view.colorizeSubviews { .clear }
                    }
                }
            }

            VBox().attach($0) {
                HGroup().attach($0) {
                    PropsTitleView().attach($0)
                        .text("Colorize")

                    UISwitch().attach($0)
                        .isOn(colorizeIsOn)
                }
                .space(4)
                .justifyContent(.center)
                .width(.fill)
                PropsInputView().attach($0)
                    .setState(\.title, "Width")
                    .setState(\.value, store.canvasSize.binder.width)
                    .onEvent(Inputs {
                        this.value?.store.canvasSize.value.width = $0
                    })
                    .width(.fill)
                PropsInputView().attach($0)
                    .setState(\.title, "Height")
                    .setState(\.value, store.canvasSize.binder.height)
                    .onEvent(Inputs {
                        this.value?.store.canvasSize.value.height = $0
                    })
                    .width(.fill)
            }
            .width(150)
            .clipToBounds(true)
            .cornerRadius(6)
            .space(4)
            .padding(all: 8)
            .alignment([.top, .left])
            .backgroundColor(UIColor.secondarySystemGroupedBackground)
        }
        .padding(py_safeArea().map { v in
            UIEdgeInsets(top: v.top + 8, left: v.left + 8, bottom: v.bottom + 8, right: v.right + 8)
        })
    }
}

extension UIView {
    func colorizeSubviews(_ color: () -> UIColor?) {
        subviews.forEach {
            $0.backgroundColor = color()
            $0.colorizeSubviews(color)
        }
    }
}
