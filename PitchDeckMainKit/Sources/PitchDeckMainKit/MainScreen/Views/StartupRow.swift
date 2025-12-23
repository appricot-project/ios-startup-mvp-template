//
//  StartupRow.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 09.12.2025.
//

import SwiftUI
import PitchDeckMainApiKit

struct StartupRow: View {
    let item: StartupItem
    
    var body: some View {
        HStack(spacing: 12) {
            if let imageURL = item.image, let url = URL(string: imageURL) {
                AsyncImage(url: url) { img in
                    img.resizable()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 48, height: 48)
                .cornerRadius(10)
            } else {
                Color.gray.opacity(0.2)
                    .frame(width: 48, height: 48)
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                Text(item.category)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(item.location)
                .font(.headline)
                .foregroundColor(.purple)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal, 8)
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        
    }
}
