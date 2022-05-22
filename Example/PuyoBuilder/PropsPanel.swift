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
        attach {
            UIScrollView().attach($0) {
                VBox().attach($0) {
                    SizeDescriptionInspector(title: "Width").attach($0)
                        .width(.fill)
                    
                    SizeDescriptionInspector(title: "Height").attach($0)
                        .width(.fill)
                    
                    InsetsInspector(title: "Margin").attach($0)
                        .width(.fill)
                    
                    InsetsInspector(title: "Padding").attach($0)
                        .width(.fill)
                    
                    BoolInspector().attach($0)
                        .set(\.state.value.title, "Activated")
                    
                    BoolInspector().attach($0)
                        .set(\.state.value.title, "FlowEnding")
                    
                    SelectionInspector(title: "Visibility", selection: [
                        .init(title: "Visible", value: Visibility.visible),
                        .init(title: "Gone", value: Visibility.gone),
                        .init(title: "Invisible", value: Visibility.invisible),
                        .init(title: "Free", value: Visibility.free),
                    ])
                    .attach($0)
                    
                    AlignmentInspector().attach($0)
                        .set(\.state.value.title, "Alignment")
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
