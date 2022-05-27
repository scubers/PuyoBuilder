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

                        let states = this.store.getState(id)

                        for type in node.availableStateTypes {
                            switch type {
                            case .activated:
                                BoolInspector().attach(vbox)
                                    .setState(\.title, states.activated.title)
                                    .setState(\.value, states.activated.state)
                                    .onEvent(states.activated.state)

                            case .flowEnding:
                                BoolInspector().attach(vbox)
                                    .setState(\.title, states.flowEnding.title)
                                    .setState(\.value, states.flowEnding.state)
                                    .onEvent(states.flowEnding.state)

                            case .margin:
                                InsetsInspector().attach(vbox)
                                    .setState(\.title, states.margin.title)
                                    .setState(\.insets, states.margin.state.distinct())
                                    .onEvent(states.margin.state)
                                    .width(.fill)
                            case .alignment:
                                AlignmentInspector().attach(vbox)
                                    .setState(\.title, states.alignment.title)
                                    .setState(\.alignment, states.alignment.state)
                                    .onEvent(states.alignment.state)

                            case .width:
                                SizeDescriptionInspector(title: "Width").attach(vbox)
                                    .state(states.width.state.map {
                                        .init(title: "Width", sizeType: $0.sizeType, fixedValue: $0.fixedValue, ratio: $0.ratio, add: $0.add, min: $0.min, max: $0.max, priority: $0.priority, shrink: $0.shrink, grow: $0.grow, aspectRatio: $0.aspectRatio)
                                    })
                                    .onEvent(states.width.state)
                                    .width(.fill)

                            case .height:
                                SizeDescriptionInspector(title: "Height").attach(vbox)
                                    .state(states.height.state.map {
                                        .init(title: "Height", sizeType: $0.sizeType, fixedValue: $0.fixedValue, ratio: $0.ratio, add: $0.add, min: $0.min, max: $0.max, priority: $0.priority, shrink: $0.shrink, grow: $0.grow, aspectRatio: $0.aspectRatio)
                                    })
                                    .onEvent(states.height.state)
                                    .width(.fill)

                            case .visibility:
                                let selection = [
                                    Selection(title: "Visible", value: Visibility.visible),
                                    .init(title: "Gone", value: Visibility.gone),
                                    .init(title: "Invisible", value: Visibility.invisible),
                                    .init(title: "Free", value: Visibility.free),
                                ]
                                let selected = states.visibility.state.map { v in
                                    selection.firstIndex(where: { $0.value == v }) ?? 0
                                }
                                SelectionInspector(title: "Visibility", selection: selection).attach(vbox)
                                    .state(selected)
                                    .onEvent(states.visibility.state)

                            case .justifyContent:
                                AlignmentInspector().attach(vbox)
                                    .setState(\.title, "JustifyContent")
                                    .setState(\.alignment, states.justifyContent.state)
                                    .onEvent(states.justifyContent.state)

                            case .padding:
                                InsetsInspector(title: "Padding").attach(vbox)
                                    .setState(\.insets, states.padding.state.distinct())
                                    .onEvent(states.padding.state)
                                    .width(.fill)
                            case .direction:
                                let selection = [
                                    Selection(title: "Horz", value: Direction.horizontal),
                                    Selection(title: "Vert", value: .vertical),
                                ]
                                let selected = states.direction.state.map { v in
                                    selection.firstIndex(where: { $0.value == v }) ?? 0
                                }
                                SelectionInspector(title: "Direction", selection: selection).attach(vbox)
                                    .state(selected)
                                    .onEvent(states.direction.state)

                            case .reverse:
                                BoolInspector().attach(vbox)
                                    .setState(\.title, "Reverse")
                                    .setState(\.value, states.reverse.state)
                                    .onEvent(states.reverse.state)

                            case .space:
                                CGFloatInspector().attach(vbox)
                                    .setState(\.title, "Space")
                                    .setState(\.value, states.space.state)
                                    .onEvent(states.space.state)

                            case .format:
                                let selection = [
                                    Selection(title: "Leading", value: Format.leading),
                                    Selection(title: "Center", value: .center),
                                    Selection(title: "Between", value: .between),
                                    Selection(title: "Round", value: .round),
                                    Selection(title: "Trailing", value: .trailing),
                                ]
                                let selected = states.format.state.map { v in
                                    selection.firstIndex(where: { $0.value == v }) ?? 0
                                }
                                SelectionInspector(title: "Format", selection: selection).attach(vbox)
                                    .state(selected)
                                    .onEvent(states.format.state)

                            case .arrange:
                                CGFloatInspector().attach(vbox)
                                    .setState(\.title, "Arrange")
                                    .setState(\.value, states.arrange.state.mapCGFloat())
                                    .onEvent(states.arrange.state.asInput { Int($0) })

                            case .itemSpace:
                                CGFloatInspector().attach(vbox)
                                    .setState(\.title, "ItemSpace")
                                    .setState(\.value, states.itemSpace.state)
                                    .onEvent(states.itemSpace.state)

                            case .runSpace:
                                CGFloatInspector().attach(vbox)
                                    .setState(\.title, "RunSpace")
                                    .setState(\.value, states.runSpace.state)
                                    .onEvent(states.runSpace.state)
                            }
                        }
                    }
                }
                .size(.fill, .wrap)
                .space(1)
                .autoJudgeScroll(true)
                .backgroundColor(UIColor.systemGroupedBackground)
            }
            .set(\.showsVerticalScrollIndicator, false)
            .size(.fill, .fill)
        }
        .backgroundColor(.secondarySystemGroupedBackground)
    }
}
