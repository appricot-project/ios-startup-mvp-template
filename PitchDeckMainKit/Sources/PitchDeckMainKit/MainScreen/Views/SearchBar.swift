//
//  SearchBar.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 09.12.2025.
//

import SwiftUI
import PitchDeckUIKit

struct SearchBar: View {
    @Binding var text: String
    @State private var debouncedTask: DispatchWorkItem?
    @State private var hasEverReachedMinLength = false
    
    private let minSearchLength = 3
    
    let onSearchChanged: (String) -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            
            TextField("Search", text: $text)
                .textFieldStyle(.plain)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .onChange(of: text) { oldValue, newValue in
                    debouncedTask?.cancel()
                    let task = DispatchWorkItem {
                        if newValue.count >= minSearchLength {
                            onSearchChanged(newValue)
                        } else if newValue.isEmpty {
                            onSearchChanged("")
                        }
                    }
                    
                    debouncedTask = task
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
                }
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color(uiColor: .blueD1))
                }
                .transition(.opacity)
                .animation(.default, value: text.isEmpty)
            }
        }
        .padding(12)
        .background(Color(uiColor: .grayD7))
        .cornerRadius(16)
        .padding(8)
    }
}
