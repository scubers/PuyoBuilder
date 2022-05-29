//
//  BuildPuzzleHandler.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/29.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Puyopuyo

protocol BuildPuzzleHandler {
    func shouldHandle(_ layerNode: LayerNode) -> Bool
    func create(with layerNode: LayerNode) -> BoxLayoutNode?
    func provider(with layerNode: LayerNode) -> PuzzleStateProvider?
    func bind(provider: PuzzleStateProvider, for node: BoxLayoutNode)
}

extension BuildPuzzleHandler {
    func _bind(provider: PuzzleStateProvider, for node: BoxLayoutNode) {
        if let node = node as? (BoxLayoutNode & AutoDisposable) {
            node.bindBuiltinProvider(provider)
        }
    }

    func bind(provider: PuzzleStateProvider, for node: BoxLayoutNode) {
        _bind(provider: provider, for: node)
    }

    func provider(with layerNode: LayerNode) -> PuzzleStateProvider? {
        BasePuzzleStateProvider()
    }
}

typealias PuzzlePiece = BoxLayoutNode & AutoDisposable

extension BoxLayoutNode where Self: AutoDisposable {
    func _bind<O: Outputing, V>(_ output: O, action: @escaping (BoxLayoutNode & AutoDisposable, V) -> Void) where O.OutputType == V {
        addDisposer(output.outputing { [weak self] v in
            if let self = self {
                action(self, v)
            }
        }, for: nil)
    }

    func bindBuiltinProvider(_ provider: PuzzleStateProvider) {
        if let provider = provider as? BasePuzzleStateProvider {
            attach()
                .activated(provider.activated.state)
                .flowEnding(provider.flowEnding.state)
                .margin(provider.margin.state)
                .alignment(provider.alignment.state)
                .width(provider.width.state)
                .height(provider.height.state)
                .visibility(provider.visibility.state)
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
