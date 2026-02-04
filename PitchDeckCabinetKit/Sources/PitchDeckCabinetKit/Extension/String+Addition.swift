//
//  String+Addition.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 13.01.2026.
//

import Foundation

extension String {

    var localized: String {
        return NSLocalizedString(self, bundle: Bundle.module, comment:"")
    }
}
