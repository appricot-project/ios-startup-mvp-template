//
//  String+Addition.swift
//  PitchDeckAuthKit
//
//  Created by Anton Redkozubov on 29.01.2026.
//

import Foundation

extension String {

    var localized: String {
        return NSLocalizedString(self, bundle: .module, comment:"")
    }
}
