//
//  PropsPanel.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Puyopuyo

class PropsPanel: ZBox {
    let store: BuilderStore
    init(store: BuilderStore) {
        self.store = store
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder argument: NSCoder) {
        fatalError()
    }

    override func buildBody() {
        let this = WeakableObject(value: self)
        attach {
            UIScrollView().attach($0) {
                VBox().attach($0) {
                    store.selected.safeBind(to: $0) { vbox, id in
                        vbox.layoutChildren.forEach { $0.removeFromSuperBox() }

                        guard let id = id, let this = this.value, let node = this.store.findNode(by: id) else {
                            return
                        }

//                        let states = this.store.getState(id)

//                        let types = node.availableStateTypes

                        for type in node.availableStateTypes {
                            switch type {
                            case .activated:
                                BoolInspector().attach(vbox)
                                    .set(\.state.value.title, "Activated")
                            case .flowEnding:
                                BoolInspector().attach(vbox)
                                    .set(\.state.value.title, "FlowEnding")
                            case .margin:
                                InsetsInspector(title: "Margin").attach(vbox)
                                    .width(.fill)
                            case .alignment:
                                AlignmentInspector().attach(vbox)
                                    .set(\.state.value.title, "Alignment")
                            case .width:
                                SizeDescriptionInspector(title: "Width").attach(vbox)
                                    .width(.fill)

                            case .height:
                                SizeDescriptionInspector(title: "Height").attach(vbox)
                                    .width(.fill)

                            case .visibility:
                                SelectionInspector(title: "Visibility", selection: [
                                    .init(title: "Visible", value: Visibility.visible),
                                    .init(title: "Gone", value: Visibility.gone),
                                    .init(title: "Invisible", value: Visibility.invisible),
                                    .init(title: "Free", value: Visibility.free),
                                ]).attach(vbox)

                            case .justifyContent:
                                AlignmentInspector().attach(vbox)
                                    .set(\.state.value.title, "JustifyContent")
                            case .padding:
                                InsetsInspector(title: "Padding").attach(vbox)
                                    .width(.fill)
                            case .direction:
                                SelectionInspector(title: "Direction", selection: [
                                    .init(title: "Horizontal", value: Direction.horizontal),
                                    .init(title: "Vertical", value: Direction.vertical),
                                ]).attach(vbox)
                            case .reverse:
                                BoolInspector().attach(vbox)
                                    .set(\.state.value.title, "Reverse")
//                            case .space:
//                                <#code#>
//                            case .format:
//                                <#code#>
//                            case .arrange:
//                                <#code#>
//                            case .itemSpace:
//                                <#code#>
//                            case .runSpace:
//                                <#code#>
                            default: break
                            }
                        }
                    }
                }
                .size(.fill, .wrap)
                .space(1)
                .autoJudgeScroll(true)
            }
            .backgroundColor(.systemBackground)
            .set(\.showsVerticalScrollIndicator, false)
            .size(.fill, .fill)
        }
    }
}
