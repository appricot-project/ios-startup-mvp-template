//
//  BasicTextField.swift
//  PitchDeckUIKit
//
//  Created by Anatoly Nevmerzhitsky on 11.12.2025.
//

import SwiftUI

public struct BasicTextField: View {
    var title = ""
    var fieldName = ""
    @Binding var fieldValue: String
    var isSecure = false
    
    public init(title: String = "", fieldName: String = "", fieldValue: Binding<String>, isSecure: Bool = false) {
        self.title = title
        self.fieldName = fieldName
        self._fieldValue = fieldValue
        self.isSecure = isSecure
    }

    public var body: some View {
        VStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            if isSecure {
                SecureField(fieldName, text: $fieldValue)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
            } else {
                TextField(fieldName, text: $fieldValue)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
            }
            Divider()
                .frame(height: 1)
                .background(Color(red: 240/255, green: 240/255, blue: 240/255))
        }
    }
}
