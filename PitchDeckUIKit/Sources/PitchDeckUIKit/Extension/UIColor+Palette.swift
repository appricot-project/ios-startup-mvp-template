//
//  Untitled.swift
//  PitchDeckUIKit
//
//  Created by Anton Redkozubov on 18.12.2025.
//

import UIKit

public extension UIColor {
    
    // MARK: - Colors
    
    static let blackD1 = UIColor(red: 15 / 255.0, green: 15 / 255.0, blue: 15 / 255.0, alpha: 1.0)
    static let blackD2 = UIColor(red: 18 / 255.0, green: 18 / 255.0, blue: 19 / 255.0, alpha: 1.0)
    static let blackD3 = UIColor(red: 24 / 255.0, green: 24 / 255.0, blue: 25 / 255.0, alpha: 1.0)
    static let blackD4 = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.65)
    static let blueD1 = UIColor(red: 0 / 255.0, green: 122 / 255.0, blue: 255 / 255.0, alpha: 1.0)
    static let blueD2 =  UIColor(red: 83 / 255.0, green: 73 / 255.0, blue: 207 / 255.0, alpha: 1.0)
    static let whiteD1 = UIColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: 1.0)
    static let whiteD2 = UIColor(red: 246 / 255.0, green: 246 / 255.0, blue: 246 / 255.0, alpha: 1.0)
    static let whiteD3 =  UIColor(red: 243 / 255.0, green: 243 / 255.0, blue: 243 / 255.0, alpha: 1.0)
    static let whiteD4 =  UIColor(red: 217 / 255.0, green: 217 / 255.0, blue: 217 / 255.0, alpha: 1.0)
    static let whiteD5 = UIColor(red: 228 / 255.0, green: 228 / 255.0, blue: 228 / 255.0, alpha: 1.0)
    static let whiteD6 =  UIColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: 0.65)
    static let purple = UIColor(red: 61 / 255.0, green: 0 / 255.0, blue: 119 / 255.0, alpha: 1.0)
    static let grayD1 = UIColor(red: 30 / 255.0, green: 30 / 255.0, blue: 31 / 255.0, alpha: 1.0)
    static let grayD2 = UIColor(red: 41 / 255.0, green: 41 / 255.0, blue: 42 / 255.0, alpha: 1.0)
    static let grayD3 = UIColor(red: 65 / 255.0, green: 65 / 255.0, blue: 66 / 255.0, alpha: 1.0)
    static let grayD4 = UIColor(red: 107 / 255.0, green: 107 / 255.0, blue: 107 / 255.0, alpha: 1.0)
    static let grayD5 = UIColor(red: 148 / 255.0, green: 148 / 255.0, blue: 148 / 255.0, alpha: 1.0)
    static let grayD6 = UIColor(red: 232 / 255.0, green: 232 / 255.0, blue: 232 / 255.0, alpha: 1.0)
    static let grayD7 = UIColor(red: 236 / 255.0, green: 236 / 255.0, blue: 236 / 255.0, alpha: 1.0)
    static let transparentGray = UIColor(red: 92 / 255, green: 92 / 255, blue: 92 / 255, alpha: 0.08)
    
    // MARK: - Global colors
    
    static let globalBackgroundColor = color(light: whiteD2, dark: blackD1)
    static let globalTitleColor = color(light: blackD1, dark: whiteD1)
    static let globalSubtitleColor = color(light: grayD5, dark: grayD5)
    static let globalSeciondarySubtitleColor = color(light: grayD4, dark: grayD5)
    static let globalHighlightedTextColor = color(light: .blueD1, dark: .blueD1)
    static let globalBorderColor = color(light: grayD6, dark: grayD2)
    static let globalFirstLayerViewColor = color(light: .whiteD1, dark: .grayD1)
    static let globalCellSeparatorColor = color(light: grayD7, dark: grayD2)
    static let globalSecondLayerViewColor = color(light: .grayD6, dark: .grayD2)
    static let globalSeparatorColor = color(light: whiteD4, dark: grayD2)
     
    // MARK: - Button colors
    
    static let primaryButtonBackgroundColor = color(light: blueD1, dark: blueD1)
    static let primaryButtonTitleColor = color(light: blackD1, dark: blackD1)
    static let primaryButtonTintColor = color(light: blackD1, dark: blackD1)
    static let primaryButtonDisabledTitleColor = color(light: grayD5, dark: grayD4)
    static let primaryButtonDisabledTintColor = color(light: grayD5, dark: grayD4)
    static let primaryButtonDisabledBackgroundColor = color(light: blueD1, dark: blackD3)
    static let primaryButtonHighlightedColor = color(light: blackD1.withAlphaComponent(0.08), dark: blackD1.withAlphaComponent(0.4))
    static let primaryButtonSubtitleColor = color(light: grayD3, dark: grayD2)

    
    // MARK: - Public methods
    
    static func color(light: UIColor, dark: UIColor) -> UIColor {
        return UIColor.init { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? dark : light
        }
    }
}
