//
//  SelectorButton.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/23.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Puyopuyo
import UIKit

class SelectorButton: ZBox, Stateful {
    struct ViewState {
        var selected: Bool
        var title: String?
    }

    let state = State(ViewState(selected: false, title: ""))

    override func buildBody() {
        attach {
            UILabel().attach($0)
                .text(binder.title)
        }
        .set(\.layer.borderColor, UIColor.systemBlue.cgColor)
        .set(\.layer.borderWidth, 1)
        .cornerRadius(4)
        .clipToBounds(true)
        .backgroundColor(binder.selected.map { v -> UIColor in
            if v {
                return UIColor.systemBlue
            }
            return UIColor.clear
        })
//        .padding(horz: 3, vert: 2)
        .padding(all: 4)
    }
}
