//
//  PropsInputView.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/23.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Puyopuyo

class PropsInputView: HBox, Stateful, Eventable, UITextFieldDelegate {
    struct ViewState {
        var title: String
        var value: CGFloat?
        var `default`: CGFloat
    }

    let state = State(ViewState(title: "Props", value: 0, default: 0))

    let emitter = SimpleIO<CGFloat>()

    override func buildBody() {
        let text = State(value: "")

        let format = NumberFormatter()
        format.allowsFloats = true
        format.minimumIntegerDigits = 1
        format.maximumFractionDigits = 2
        format.minimumFractionDigits = 0
        state.binder.value.distinct().safeBind(to: self) { this, value in
            text.value = format.string(from: NSNumber(value: value ?? this.state.value.default)) ?? "Nan"
        }

        let this = WeakableObject(value: self)

        attach {
            PropsTitleView().attach($0)
                .text(binder.title)
                .width(.fill)
                .textAlignment(.center)
                .margin(vert: 8)

            UITextField().attach($0)
                .text(text)
                .set(\.delegate, self)
                .onControlEvent(.editingChanged, Inputs {
                    let value = format.number(from: $0.text ?? "") ?? NSNumber(value: Double(this.value?.state.value.default ?? 0))
                    this.value?.emit(CGFloat(value.floatValue))
                })
                .size(.fill, .fill)
                .cornerRadius(4)
                .clipToBounds(true)
                .keyboardType(.numberPad)
                .borderWidth(1)
                .borderColor(UIColor.separator)
                .margin(vert: 4)
        }
        .space(4)
        .justifyContent(.center)
        .size(.fill, 40)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        let result = string.trimmingCharacters(in: CharacterSet(charactersIn: "1234567890.").inverted)
        return result.count == string.count
    }
}
