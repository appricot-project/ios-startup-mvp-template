//
//  File.swift
//  PitchDeckCabinetKit
//
//  Created by Anton Redkozubov on 05.02.2026.
//

import Foundation

extension String {

    var localized: String {
        return NSLocalizedString(self, bundle: Bundle.module, comment:"")
    }
}
