//
//  AlignmentInspector.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/23.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Puyopuyo

class AlignmentInspector: VBox, Stateful, Eventable {
    struct ViewState {
        var title: String
        var alignment: Alignment
    }

    let state = State(ViewState(title: "", alignment: .none))

    let emitter = SimpleIO<Alignment>()

    override func buildBody() {
        let this = WeakableObject(value: self)
        attach {
            PropsSectionTitleView().attach($0)
                .text(binder.title)
                .width(.fill)

            VFlow(count: 2).attach($0) {
                for target in [Alignment.top, .bottom, .left, .right, .horzCenter, .vertCenter] {
                    createButton(title: "\(target)", target: target, selected: binder.alignment.asOutput(), onClick: Inputs {
                        this.value?.notifyToggle($0)
                    }).attach($0)
                }
            }
            .space(4)
            .width(.fill)
        }
        .justifyContent(.left)
        .padding(all: 8)
        .space(8)
//        .animator(VerticalExpandAnimator())
        .backgroundColor(.secondarySystemBackground)
        .width(.fill)
    }

    func notifyToggle(_ alignment: Alignment) {
        var selected = state.value.alignment
        if selected.contains(alignment) {
            selected.remove(alignment)
        } else {
            selected.insert(alignment)
        }
        state.value.alignment = selected

        emit(selected)
    }
}

private func createButton(title: String, target: Alignment, selected: Outputs<Alignment>, onClick: Inputs<Alignment>) -> UIButton {
    UIButton().attach()
        .text(title)
        .set(\.layer.borderColor, UIColor.systemBlue.cgColor)
        .set(\.layer.borderWidth, 1)
        .cornerRadius(4)
        .clipToBounds(true)
        .backgroundColor(selected.map { selected -> UIColor in
            if selected.contains(target) {
                return UIColor.systemBlue
            } else {
                return UIColor.clear
            }
        })
        .onControlEvent(.touchUpInside, onClick.asInput { _ in target })
        .size(.fill, 40)
        .view
}
