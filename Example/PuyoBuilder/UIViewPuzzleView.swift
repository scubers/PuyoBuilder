//
//  UIViewPuzzleView.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/29.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Puyopuyo
import UIKit

extension BoxLayoutNode where Self: AutoDisposable {
    private func _bind<O: Outputing, V>(_ output: O, action: @escaping (BoxLayoutNode & AutoDisposable, V) -> Void) where O.OutputType == V {
        addDisposer(output.outputing { [weak self] v in
            if let self = self {
                action(self, v)
            }
        }, for: nil)
    }

    func bindBuiltinProvider(_ provider: PuzzleStateProvider) {
        if let provider = provider as? BasePuzzleStateProvider {
            _bind(provider.activated.state, action: { $0.layoutMeasure.activated = $1 })
            _bind(provider.flowEnding.state, action: { $0.layoutMeasure.flowEnding = $1 })
            _bind(provider.margin.state, action: { $0.layoutMeasure.margin = $1 })
            _bind(provider.alignment.state, action: { $0.layoutMeasure.alignment = $1 })
            _bind(provider.width.state, action: { $0.layoutMeasure.size.width = $1 })
            _bind(provider.height.state, action: { $0.layoutMeasure.size.height = $1 })
            _bind(provider.visibility.state, action: { $0.layoutVisibility = $1 })
        }

        if let provider = provider as? BoxPuzzleStateProvider {
            _bind(provider.padding.state, action: { $0.layoutReg.padding = $1 })
            _bind(provider.justifyContent.state, action: { $0.layoutReg.justifyContent = $1 })
        }
        if let provider = provider as? LinearPuzzleStateProvider {
            _bind(provider.space.state, action: { $0.layoutLinearReg.space = $1 })
            _bind(provider.direction.state, action: { $0.layoutLinearReg.direction = $1 })
            _bind(provider.reverse.state, action: { $0.layoutLinearReg.reverse = $1 })
            _bind(provider.format.state, action: { $0.layoutLinearReg.format = $1 })
        }
        if let provider = provider as? FlowPuzzleStateProvider {
            _bind(provider.runFormat.state, action: { $0.layoutFlowReg.runFormat = $1 })
            _bind(provider.itemSpace.state, action: { $0.layoutFlowReg.itemSpace = $1 })
            _bind(provider.runSpace.state, action: { $0.layoutFlowReg.runSpace = $1 })
            _bind(provider.arrange.state, action: { $0.layoutFlowReg.arrange = $1 })
        }
    }

    private var layoutReg: Regulator { layoutMeasure as! Regulator }
    private var layoutZReg: ZRegulator { layoutMeasure as! ZRegulator }
    private var layoutLinearReg: LinearRegulator { layoutMeasure as! LinearRegulator }
    private var layoutFlowReg: FlowRegulator { layoutMeasure as! FlowRegulator }
}
