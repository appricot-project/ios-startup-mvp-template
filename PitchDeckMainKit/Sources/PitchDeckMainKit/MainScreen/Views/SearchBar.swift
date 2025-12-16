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
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            
            TextField("Search", text: $text)
                .textFieldStyle(.plain)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .onChange(of: text) { newValue in
                    debouncedTask?.cancel()
                    
                    let task = DispatchWorkItem {
                        if newValue.count >= 3 || newValue.isEmpty {
                            onSearchChanged(newValue)
                        }
                    }
                    
                    debouncedTask = task
                    DispatchQueue.main.async(execute: task)
                }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(8)
    }
}
