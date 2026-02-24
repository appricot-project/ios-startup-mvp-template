//
//  StartupRow.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 09.12.2025.
//

import SwiftUI
import PitchDeckUIKit
import PitchDeckMainApiKit
import PitchDeckCoreKit

struct StartupRow: View {
    let item: StartupItem
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            if let imageURL = item.image,
               !imageURL.isEmpty,
               imageURL != (Config.strapiDataURL ?? ""),
               let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color(uiColor: .globalCellSeparatorColor)
                            LoadingView(size: .small)
                                .frame(width: 24, height: 24)
                        }
                        .frame(width: 48, height: 48)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                        )
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                            .clipped()
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                            )
                    case .failure:
                        Color(uiColor: .globalCellSeparatorColor)
                            .frame(width: 48, height: 48)
                            .cornerRadius(10)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                            )
                    @unknown default:
                        Color(uiColor: .globalCellSeparatorColor)
                            .frame(width: 48, height: 48)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                            )
                    }
                }
            } else {
                Color(uiColor: .globalCellSeparatorColor)
                    .frame(width: 48, height: 48)
                    .cornerRadius(10)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .font(.caption)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                    )
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
        .background(Color(uiColor: .globalCellSeparatorColor))
        .cornerRadius(16)
        .padding(.horizontal, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
        .listRowBackground(Color(UIColor.globalBackgroundColor))
    }
}
