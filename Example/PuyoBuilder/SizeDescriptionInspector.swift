//
//  SizeDescriptionInspector.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/23.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Puyopuyo

class SizeDescriptionInspector: VBox, Stateful {
    struct ViewState {
        var title: String
        var sizeType: SizeDescription.SizeType
        var fixedValue: CGFloat = 0
        var ratio: CGFloat = 0
        var add: CGFloat = 0
        var min: CGFloat = 0
        var max: CGFloat = 0
        var priority: CGFloat = 0
        var shrink: CGFloat = 0
        var grow: CGFloat = 0
        var aspectRatio: CGFloat = 0
    }

    let state = State<ViewState>(.init(title: "", sizeType: .wrap))

    init(title: String) {
        super.init(frame: .zero)
        self.state.value.title = title
    }

    @available(*, unavailable)
    required init?(coder argument: NSCoder) {
        fatalError()
    }

    override func buildBody() {
//        let this = WeakableObject(value: self)

        attach {
            PropsSectionTitleView().attach($0)
                .text(binder.title)
                .width(.fill)

            HBox().attach($0) {
                PropsTitleView().attach($0)
                    .text("Type")

                DropDownableView().attach($0)
                    .state(binder.sizeType.map { "\($0)" })
                    .onTap(to: self) { this, _ in
                        let selection = [
                            Selection(title: "Fixed", value: SizeDescription.SizeType.fixed),
                            .init(title: "Wrap", value: .wrap),
                            .init(title: "Ratio", value: .ratio),
                            .init(title: "AspectRatio", value: .aspectRatio),
                        ]

                        presentSelection(from: this, selection, selected: selection.firstIndex(where: { $0.value == this.state.value.sizeType }) ?? 0, result: Inputs {
                            this.state.value.sizeType = selection[$0].value
                            this.notify(value: selection[$0].value, keyPath: \.sizeType)
                        })
                    }
            }
            .space(4)
            .justifyContent(.center)

            VFlow(count: 2).attach($0) {
                PropsInputView().attach($0)
                    .set(\.state.value.title, "Fix")
                    .set(\.state.value.default, 0)
                    .set(\.state.value.value, binder.fixedValue.distinct().map { Optional.some($0) })
                    .visibility(binder.sizeType.map { ($0 == .fixed).py_visibleOrGone() })
                    .onEvent(to: self) { this, v in
                        this.notify(value: v, keyPath: \.fixedValue)
                    }

                PropsInputView().attach($0)
                    .set(\.state.value.title, "Ratio")
                    .set(\.state.value.default, 0)
                    .set(\.state.value.value, binder.ratio.distinct().map { Optional.some($0) })
                    .visibility(binder.sizeType.map { ($0 == .ratio).py_visibleOrGone() })
                    .onEvent(to: self) { this, v in
                        this.notify(value: v, keyPath: \.ratio)
                    }

                PropsInputView().attach($0)
                    .set(\.state.value.title, "Aspect")
                    .set(\.state.value.default, 0)
                    .set(\.state.value.value, binder.aspectRatio.distinct().map { Optional.some($0) })
                    .visibility(binder.sizeType.map { ($0 == .aspectRatio).py_visibleOrGone() })
                    .onEvent(to: self) { this, v in
                        this.notify(value: v, keyPath: \.aspectRatio)
                    }

                PropsInputView().attach($0)
                    .set(\.state.value.title, "Shrink")
                    .set(\.state.value.default, 0)
                    .set(\.state.value.value, binder.shrink.distinct().map { Optional.some($0) })
                    .visibility(binder.sizeType.map { ($0 == .wrap).py_visibleOrGone() })
                    .onEvent(to: self) { this, v in
                        this.notify(value: v, keyPath: \.shrink)
                    }

                PropsInputView().attach($0)
                    .set(\.state.value.title, "Grow")
                    .set(\.state.value.default, 0)
                    .set(\.state.value.value, binder.grow.distinct().map { Optional.some($0) })
                    .visibility(binder.sizeType.map { ($0 == .wrap).py_visibleOrGone() })
                    .onEvent(to: self) { this, v in
                        this.notify(value: v, keyPath: \.grow)
                    }

                PropsInputView().attach($0)
                    .set(\.state.value.title, "Priority")
                    .set(\.state.value.default, 0)
                    .set(\.state.value.value, binder.priority.distinct().map { Optional.some($0) })
                    .visibility(binder.sizeType.map { ($0 == .wrap).py_visibleOrGone() })
                    .onEvent(to: self) { this, v in
                        this.notify(value: v, keyPath: \.priority)
                    }

                PropsInputView().attach($0)
                    .set(\.state.value.title, "Add")
                    .set(\.state.value.default, 0)
                    .set(\.state.value.value, binder.add.distinct().map { Optional.some($0) })
                    .visibility(binder.sizeType.map { ($0 == .wrap).py_visibleOrGone() })
                    .onEvent(to: self) { this, v in
                        this.notify(value: v, keyPath: \.add)
                    }

                PropsInputView().attach($0)
                    .set(\.state.value.title, "Max")
                    .set(\.state.value.default, 0)
                    .set(\.state.value.value, binder.max.distinct().map { Optional.some($0) })
                    .visibility(binder.sizeType.map { ($0 == .wrap).py_visibleOrGone() })
                    .onEvent(to: self) { this, v in
                        this.notify(value: v, keyPath: \.max)
                    }

                PropsInputView().attach($0)
                    .set(\.state.value.title, "Min")
                    .set(\.state.value.default, 0)
                    .set(\.state.value.value, binder.min.distinct().map { Optional.some($0) })
                    .visibility(binder.sizeType.map { ($0 == .wrap).py_visibleOrGone() })
                    .onEvent(to: self) { this, v in
                        this.notify(value: v, keyPath: \.min)
                    }

                UIView().attach($0)
                    .width(.fill)
                    .visibility(binder.sizeType.map { ($0 != .wrap).py_visibleOrGone() })
            }
            .itemSpace(4)
            .width(.fill)
        }
        .justifyContent(.left)
        .padding(all: 8)
        .space(8)
        .animator(Animators.default)
        .backgroundColor(.secondarySystemBackground)
    }

    func notify<V>(value: V, keyPath: WritableKeyPath<ViewState, V>) {
        var state = self.state.value
        state[keyPath: keyPath] = value
        var result: SizeDescription
        switch state.sizeType {
        case .fixed:
            result = .fix(state.fixedValue)
        case .ratio:
            result = .ratio(state.ratio)
        case .wrap:
            result = .wrap(add: state.add, min: state.min, max: state.max, priority: state.priority, shrink: state.shrink, grow: state.grow)
        case .aspectRatio:
            result = .aspectRatio(state.aspectRatio)
        }

        print(result)
    }

    func createNumberInputGroup(title: String, data: Outputs<String>, event: Inputs<String>) -> UIView {
        HBox().attach {
            PropsTitleView().attach($0)
                .text(title)
                .width(.fill)
                .textAlignment(.center)
                .margin(vert: 8)

            UITextField().attach($0)
                .text(data)
                .onControlEvent(.editingChanged, event.asInput { $0.text ?? "" })
                .size(.fill, .fill)
                .cornerRadius(4)
                .clipToBounds(true)
                .borderWidth(1)
                .borderColor(UIColor.separator)
                .margin(vert: 4)
        }
        .space(4)
        .justifyContent(.center)
        .size(.fill, 40)
        .view
    }
}
