//
//  MarkupStyleFont.swift
//
//
//  Created by https://zhgchg.li on 2023/2/4.
//
//

import Foundation
import UIKit

public struct MarkupStyleFont: MarkupStyleItem {
    public enum CaseStyle {
        case lowercase
        case uppercase
    }
    public enum FontWeight {
        case style(FontWeightStyle)
        case rawValue(CGFloat)
    }
    public enum FontFamily {
        case familyNames([String])

        func getFont(size: CGFloat) -> UIFont? {
            switch self {
            case .familyNames(let familyNames):
                for familyName in familyNames {
                    if let font = UIFont(name: familyName, size: size) {
                        return font
                    }
                }
                return nil
            }
        }
    }
    public enum FontWeightStyle: String, CaseIterable {
        case ultraLight, light, thin, regular, medium, semibold, bold, heavy, black

        public init?(rawValue: String) {
            guard let matchedStyle = FontWeightStyle.allCases.first(where: { style in
                return rawValue.lowercased().contains(style.rawValue)
            }) else {
                return nil
            }

            self = matchedStyle
        }

        init?(font: UIFont) {
            if let traits = font.fontDescriptor.fontAttributes[.traits] as? [UIFontDescriptor.TraitKey: Any], let weight = traits[.weight] as? UIFont.Weight {
                self = weight.convertFontWeightStyle()
                return
            } else if let weightName = font.fontDescriptor.object(forKey: .face) as? String, let weight = Self.init(rawValue: weightName) {
                self = weight
                return
            }

            return nil
        }
    }

    public var size: CGFloat?
    public var weight: FontWeight?
    public var italic: Bool?
    public var bold: Bool?
    public var familyName: FontFamily?

    public init(size: CGFloat? = nil, weight: FontWeight? = nil, bold: Bool? = nil, italic: Bool? = nil, familyName: FontFamily? = nil) {
        self.size = size
        self.weight = weight
        self.bold = bold
        self.italic = italic
        self.familyName = familyName
    }

    mutating func fillIfNil(from: MarkupStyleFont?) {
        self.size = self.size ?? from?.size
        self.weight = self.weight ?? from?.weight
        self.italic = self.italic ?? from?.italic
        self.bold = self.bold ?? from?.bold
        self.familyName = self.familyName ?? from?.familyName
    }

    func isNil() -> Bool {
        return !([size,
                  weight,
                  italic,
                  bold,
                  familyName] as [Any?]).contains(where: { $0 != nil})
    }

    func sizeOf(string: String) -> CGSize? {
        guard let font = getFont() else {
            return nil
        }

        return (string as NSString).size(withAttributes: [.font: font])
    }
}

extension MarkupStyleFont {

    public init(_ font: UIFont) {
        self.size = font.pointSize
        self.italic = font.fontDescriptor.symbolicTraits.contains(.traitItalic)
        self.bold = font.fontDescriptor.symbolicTraits.contains(.traitBold)
        if let fontWeight = FontWeightStyle.init(font: font) {
            self.weight = FontWeight.style(fontWeight)
        }
        self.familyName = .familyNames([font.familyName])
    }

    func getFont() -> UIFont? {
        guard !isNil() else { return nil }

        var traits: UIFontDescriptor.SymbolicTraits = []

        let size = (self.size ?? MarkupStyle.default.font.size) ?? UIFont.systemFontSize
        let weight = self.weight?.convertToUIFontWeight() ?? .regular

        // There is no direct method in UIFont to specify the font family, italic and weight together.

        let font: UIFont
        if let familyFont = self.familyName?.getFont(size: size) {
            // Custom Font
            font = familyFont
        } else {
            // System Font
            font = UIFont.systemFont(ofSize: size, weight: weight)
        }

        if bold == true {
            traits.insert(.traitBold)
        }

        if let italic = self.italic, italic {
            traits.insert(.traitItalic)
        }

        return font.with(weight: weight, symbolicTraits: traits)
    }
}

extension MarkupStyleFont.FontWeight {
    func convertToUIFontWeight() -> UIFont.Weight {
        switch self {
        case .style(let style):
            switch style {
            case .regular:
                return .regular
            case .ultraLight:
                return .ultraLight
            case .light:
                return .light
            case .thin:
                return .thin
            case .medium:
                return .medium
            case .semibold:
                return .semibold
            case .bold:
                return .bold
            case .heavy:
                return .heavy
            case .black:
                return .black
            }
        case .rawValue(let value):
            return UIFont.Weight(rawValue: value)
        }
    }
}

private extension UIFont.Weight {
    func convertFontWeightStyle() -> MarkupStyleFont.FontWeightStyle {
        switch self {
        case .regular:
            return .regular
        case .ultraLight:
            return .ultraLight
        case .light:
            return .light
        case .thin:
            return .thin
        case .medium:
            return .medium
        case .semibold:
            return .semibold
        case .bold:
            return .bold
        case .heavy:
            return .heavy
        case .black:
            return .black
        default:
            return .regular
        }
    }
}

private extension UIFont {

    /// Returns a font object that is the same as the receiver but which has the specified weight and symbolic traits
    func with(weight: Weight, symbolicTraits: UIFontDescriptor.SymbolicTraits) -> UIFont {

        var mergedsymbolicTraits = fontDescriptor.symbolicTraits
        mergedsymbolicTraits.formUnion(symbolicTraits)

        var traits = fontDescriptor.fontAttributes[.traits] as? [UIFontDescriptor.TraitKey: Any] ?? [:]
        traits[.weight] = weight
        traits[.symbolic] = mergedsymbolicTraits.rawValue

        var fontAttributes: [UIFontDescriptor.AttributeName: Any] = [:]
        fontAttributes[.family] = familyName
        fontAttributes[.traits] = traits

        let font = UIFont(descriptor: UIFontDescriptor(fontAttributes: fontAttributes), size: pointSize)
        return UIFontMetrics.default.scaledFont(for: font)
    }
}
