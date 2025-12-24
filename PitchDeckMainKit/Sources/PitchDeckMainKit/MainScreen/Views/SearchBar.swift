//
//  SearchBar.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 09.12.2025.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    let onSearchChanged: (String) -> Void
    
    @State private var debouncedTask: DispatchWorkItem?
    @State private var hasEverReachedMinLength = false  // Новое состояние
    
    private let minSearchLength = 3
    
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
                        } else if newValue.isEmpty &&
                                    oldValue.count >= minSearchLength {
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
                        .foregroundStyle(.secondary)
                }
                .transition(.opacity)
                .animation(.default, value: text.isEmpty)
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(8)
    }
}
