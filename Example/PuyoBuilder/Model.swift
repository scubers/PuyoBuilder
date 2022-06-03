//
//  Model.swift
//  PuyoBuilder_Example
//
//  Created by J on 2022/5/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
// import HandyJSON
import Puyopuyo

typealias HandyJSON = Codable
typealias HandyJSONEnum = Codable

extension Encodable {
    func encodeToJson(pretty: Bool = false) -> String? {
        let encoder = JSONEncoder()
        if pretty {
            encoder.outputFormatting = .prettyPrinted
        }
        if let data = try? encoder.encode(self), let json = String(data: data, encoding: .utf8) {
            return json
        }
        return nil
    }
}

extension Decodable {
    static func from(json: String?) -> Self? {
        guard let json = json else {
            return nil
        }

        guard let data = json.data(using: .utf8) else {
            return nil
        }

        return try? JSONDecoder().decode(Self.self, from: data)
    }
}

extension Encodable where Self: Decodable {
    func jsonCopy() -> Self? {
        return Self.from(json: encodeToJson())
    }
}

class PuzzleCanvas: HandyJSON {
    required init() {}

    var width: CGFloat = 250
    var height: CGFloat = 250

    var root: PuzzleNode?
}

class PuzzleNode: HandyJSON {
    required init() {}

    enum NodeType: String, HandyJSONEnum {
        case concrete
        case box
        case group
    }

    enum LayoutType: String, HandyJSONEnum {
        case linear
        case flow
        case z
    }

    func config(_ action: (PuzzleNode) -> Void) -> PuzzleNode {
        action(self)
        return self
    }

    var id = UUID().description

    /// layout or normal view
    var nodeType: NodeType = .box

    var layoutType: LayoutType?

    var concreteViewType: String?

    ///
    /// subclassing
    var titleDescr: String {
        fatalError()
    }

    var children: [PuzzleNode]?

    func append(_ child: PuzzleNode) {
        children?.append(child)
        if children == nil {
            children = [child]
        }
    }

    // MARK: - Base Props

    var activated: Bool?
    var flowEnding: Bool?
    var margin: PuzzleInsets?
    var alignment: PuzzleAlignment?
    var width: PuzzleSizeDesc?
    var height: PuzzleSizeDesc?
    var visibility: PuzzleVisibility?

    // MARK: - Regulator Props

    var justifyContent: PuzzleAlignment?
    var padding: PuzzleInsets?

    // MARK: - Linear Props

    var direction: PuzzleDirection?
    var reverse: Bool?
    var space: CGFloat?
    var format: PuzzleFormat?

    // MARK: - Flow props

    var arrange: Int?
    var itemSpace: CGFloat?
    var runSpace: CGFloat?
    var runForamt: PuzzleFormat?

    // MARK: - Extra

//    var extra: [String: HandyJSON]?
    var extraJson: String?
}

extension PuzzleNode {
    // MARK: Methods

    var rootable: Bool {
        nodeType == .box
    }

    func copy(_ action: ((PuzzleNode) -> PuzzleNode)?) -> PuzzleNode {
        let singleCopy = action ?? { $0.jsonCopy()! }
        let new = singleCopy(self)
        new.children = children?.map { $0.copy(singleCopy) }
        return new
    }

    func getExtra<T: Decodable>() -> T? {
        return T.from(json: extraJson)
    }

    func setExtra<T: Encodable>(_ value: T?) {
        extraJson = value?.encodeToJson()
    }
}

struct PuzzleInsets: HandyJSON {
    var top: CGFloat?
    var left: CGFloat?
    var bottom: CGFloat?
    var right: CGFloat?

    func getInsets() -> UIEdgeInsets {
        return .init(top: top ?? 0, left: left ?? 0, bottom: bottom ?? 0, right: right ?? 0)
    }

    static func from(_ insets: UIEdgeInsets) -> PuzzleInsets {
        return .init(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right)
    }
}

class PuzzleSizeDesc: HandyJSON {
    required init() {}

    enum SizeType: String, HandyJSONEnum {
        case fixed
        case wrap
        case ratio
        case aspectRatio
    }

    var sizeType: SizeType = .wrap

    var fixedValue: CGFloat?
    var ratio: CGFloat?
    var add: CGFloat?
    var min: CGFloat?
    var max: CGFloat?
    var priority: CGFloat?
    var shrink: CGFloat?
    var grow: CGFloat?
    var aspectRatio: CGFloat?

    func getSizeDescription() -> SizeDescription {
        switch sizeType {
        case .fixed:
            return .fix(fixedValue ?? 0)
        case .ratio:
            return .ratio(ratio ?? 1)
        case .wrap:
            return .wrap(add: add ?? 0, min: min ?? 0, max: max ?? .greatestFiniteMagnitude, priority: priority ?? 0, shrink: shrink ?? 0, grow: grow ?? 0)
        case .aspectRatio:
            return .aspectRatio(aspectRatio ?? 0)
        }
    }

    static func from(_ sizeDescription: SizeDescription) -> PuzzleSizeDesc {
        let size = PuzzleSizeDesc()
        switch sizeDescription.sizeType {
        case .fixed:
            size.sizeType = .fixed
            size.fixedValue = sizeDescription.fixedValue
        case .ratio:
            size.sizeType = .ratio
            size.ratio = sizeDescription.ratio
        case .wrap:
            size.sizeType = .wrap
            size.add = sizeDescription.add
            size.min = sizeDescription.min
            size.max = sizeDescription.max
            size.priority = sizeDescription.priority
            size.shrink = sizeDescription.shrink
            size.grow = sizeDescription.grow
        case .aspectRatio:
            size.sizeType = .aspectRatio
            size.aspectRatio = sizeDescription.aspectRatio
        }
        return size
    }
}

class PuzzleAlignment: HandyJSON {
    required init() {}
    enum AlignmentType: String, HandyJSONEnum {
        case none, top, left, bottom, right, horzCenter, vertCenter
    }

    var alignment: [AlignmentType] = [.none]
    var centerRatio: CGPoint?

    func getAlignment() -> Alignment {
        var rawValue = 0
        if alignment.contains(.none) { rawValue = rawValue | Alignment.none.rawValue }
        if alignment.contains(.top) { rawValue = rawValue | Alignment.top.rawValue }
        if alignment.contains(.left) { rawValue = rawValue | Alignment.left.rawValue }
        if alignment.contains(.bottom) { rawValue = rawValue | Alignment.bottom.rawValue }
        if alignment.contains(.right) { rawValue = rawValue | Alignment.right.rawValue }
        if alignment.contains(.horzCenter) { rawValue = rawValue | Alignment.horzCenter.rawValue }
        if alignment.contains(.vertCenter) { rawValue = rawValue | Alignment.vertCenter.rawValue }
        return .init(rawValue: rawValue, ratio: centerRatio ?? .zero)
    }

    static func from(_ alignment: Alignment) -> PuzzleAlignment {
        let align = PuzzleAlignment()
        if alignment.centerRatio != .zero {
            align.centerRatio = alignment.centerRatio
        }
        align.alignment = []
        if alignment.contains(.top) { align.alignment.append(.top) }
        if alignment.contains(.left) { align.alignment.append(.left) }
        if alignment.contains(.bottom) { align.alignment.append(.bottom) }
        if alignment.contains(.right) { align.alignment.append(.right) }
        if alignment.contains(.horzCenter) { align.alignment.append(.horzCenter) }
        if alignment.contains(.vertCenter) { align.alignment.append(.vertCenter) }
        return align
    }
}

enum PuzzleDirection: String, HandyJSONEnum {
    case horizontal, vertical

    func getDirection() -> Direction {
        switch self {
        case .horizontal:
            return .horizontal
        case .vertical:
            return .vertical
        }
    }

    static func from(_ direction: Direction) -> PuzzleDirection {
        switch direction {
        case .horizontal:
            return .horizontal
        case .vertical:
            return .vertical
        }
    }
}

enum PuzzleFormat: String, HandyJSONEnum {
    case leading, center, between, round, trailing

    func getFormat() -> Format {
        switch self {
        case .leading:
            return .leading
        case .center:
            return .center
        case .between:
            return .between
        case .round:
            return .round
        case .trailing:
            return .trailing
        }
    }

    static func from(_ format: Format) -> PuzzleFormat {
        switch format {
        case .leading:
            return .leading
        case .center:
            return .center
        case .between:
            return .between
        case .round:
            return .round
        case .trailing:
            return .trailing
        }
    }
}

enum PuzzleVisibility: String, HandyJSONEnum {
    case visible, invisible, gone, free

    func getVisibility() -> Visibility {
        switch self {
        case .visible:
            return .visible
        case .invisible:
            return .invisible
        case .gone:
            return .gone
        case .free:
            return .free
        }
    }

    static func from(_ visibility: Visibility) -> PuzzleVisibility {
        switch visibility {
        case .visible:
            return .visible
        case .invisible:
            return .invisible
        case .gone:
            return .gone
        case .free:
            return .free
        }
    }
}
