//
//  CategoryRow.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 09.12.2025.
//

import SwiftUI
import PitchDeckMainApiKit

struct CategoryRow: View {
    let categories: [CategoryItem]
//    @Binding var selected: String?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories) { category in
                    Text(category.title)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
//                            selected == category.id
//                            ? Color.blue.opacity(0.2)
//                            :
                                Color.gray.opacity(0.1)
                        )
                        .cornerRadius(16)
                        .onTapGesture {
//                            selected = category.id
                        }
                }
            }
            .padding(.horizontal, 8)
        }
    }
}
