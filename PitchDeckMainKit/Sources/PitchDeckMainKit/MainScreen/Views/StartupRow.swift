//
//  StartupRow.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 09.12.2025.
//

import SwiftUI
import PitchDeckUIKit
import PitchDeckMainApiKit

struct StartupRow: View {
    let item: StartupItem
    let onTap: () -> Void
    
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
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .lineLimit(1)
                Text(item.category)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(item.location)
                .font(.subheadline)
                .foregroundColor(Color(uiColor: .blueD1))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(uiColor: .grayD7))
        .cornerRadius(16)
        .padding(.horizontal, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}
