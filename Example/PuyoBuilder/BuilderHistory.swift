//
//  BuilderHistory.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/6/5.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Puyopuyo

class BuilderHistory<T>: ChangeNotifier {
    let maxCount: Int

    init(count: Int, first: T) {
        self.maxCount = count
        history = [first]
        history.reserveCapacity(maxCount)
    }

    var changeNotifier: Outputs<Void> { notifier.asOutput() }

    private let notifier = SimpleIO<Void>()

    private(set) var history: [T]

    private(set) var currentIndex = 0

    var canUndo: Bool { currentIndex > 0 }
    var canRedo: Bool { currentIndex < history.count - 1 }

    var currentState: T { history[currentIndex] }

    func push(_ next: T) {
        if history.count == maxCount {
            history.removeFirst()
        }
        history.append(next)
        currentIndex += 1
        history.removeLast(max(0, history.count - currentIndex - 1))
        notifier.input(value: ())
    }

    func undo() {
        guard canUndo else {
            return
        }
        currentIndex -= 1
        notifier.input(value: ())
    }

    func redo() {
        guard canRedo else {
            return
        }
        currentIndex += 1
        notifier.input(value: ())
    }
}
