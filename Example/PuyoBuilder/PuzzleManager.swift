//
//  PuzzleTemplate.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/29.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Puyopuyo

class PuzzleManager {
    private init() {}

    static let shared = PuzzleManager()

    private(set) var templates: [PuzzleTemplate] = [
        UIViewPuzzleTemplate(),
        UILabelPuzzleTemplate(),
        UIImagePuzzleTemplate(),
        LinearBoxPuzzleTemplate(),
        FlowBoxPuzzleTemplate(),
        ZBoxPuzzleTemplate(),
        LinearGroupPuzzleTemplate(),
        FlowGroupPuzzleTemplate(),
        ZGroupPuzzleTemplate(),
    ]

    func addTemplate(_ template: PuzzleTemplate) {
        templates.append(template)
    }
}
