//
//  SelectionInspector.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/23.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Puyopuyo

class SelectionInspector<V>: HBox, Eventable {
    private let selection: [Selection<V>]
    let title: String
    init(title: String, selection: [Selection<V>]) {
        self.title = title
        self.selection = selection
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder argument: NSCoder) {
        fatalError()
    }

    let emitter = SimpleIO<V>()

    override func buildBody() {
        let this = WeakableObject(value: self)
        let state = State(0)
        attach {
            PropsTitleView().attach($0)
                .text(title)
                .textAlignment(.center)
                .margin(vert: 8)

            DropDownableView().attach($0)
                .set(\.state.value, state.map {
                    guard let selection = this.value?.selection, $0 < selection.count else {
                        return ""
                    }
                    return "\(selection[$0].value)"
                })
        }
        .onTap(to: self) { this, _ in
            presentSelection(from: this, this.selection, selected: state.value, result: Inputs {
                state.value = $0
                this.notify(index: $0)
            })
        }
        .space(8)
        .width(.fill)
        .backgroundColor(.secondarySystemBackground)
        .padding(all: 8)
        .justifyContent(.center)
    }

    func notify(index: Int) {
        if index < selection.count {
            emit(selection[index].value)
        }
    }
}
