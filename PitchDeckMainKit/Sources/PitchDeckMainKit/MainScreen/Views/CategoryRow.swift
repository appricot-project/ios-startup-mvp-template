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
    
    @State private var hasAppeared = false
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories) { category in
                        categoryChip(for: category)
                            .id(category.id)
                    }
                }
                .padding(.horizontal, 8)
            }
            .onChange(of: selectedCategoryId) { newId in
                if let id = newId, hasAppeared {
                    withAnimation {
                        proxy.scrollTo(id, anchor: .center)
                    }
                }
            }
            .onAppear {
                if let id = selectedCategoryId, !hasAppeared {
                    proxy.scrollTo(id, anchor: .center)
                    hasAppeared = true
                }
            }
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
                    .fill(isSelected ? Color(uiColor: .blueD1) : Color(uiColor: .globalCellSeparatorColor))
            )
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    let newValue = isSelected ? nil : category.id
                    onCategoryChanged(newValue)
                }
            }
    }
}
