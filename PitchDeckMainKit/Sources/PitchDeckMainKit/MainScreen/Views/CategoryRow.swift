//
//  CategoryRow.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 09.12.2025.
//

import SwiftUI
import PitchDeckUIKit
import PitchDeckMainApiKit

struct CategoryRow: View {
    let categories: [CategoryItem]
    let selectedCategoryId: Int?
    let onCategoryChanged: (Int?) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories) { category in
                    categoryChip(for: category)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
    
    @ViewBuilder
    private func categoryChip(for category: CategoryItem) -> some View {
        let isSelected = selectedCategoryId == category.id
        
        Text(category.title)
            .font(.system(size: 15, weight: isSelected ? .semibold : .medium))
            .foregroundStyle(isSelected ? Color(uiColor: .whiteD1) : Color(uiColor: .globalTitleColor))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(isSelected ? Color(uiColor: .blueD1) : Color(uiColor: .grayD7))
            )
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    let newValue = isSelected ? nil : category.id
                    onCategoryChanged(newValue)
                }
            }
    }
}
