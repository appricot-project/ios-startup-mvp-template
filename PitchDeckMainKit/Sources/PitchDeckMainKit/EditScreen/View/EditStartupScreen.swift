//
//  EditStartupScreen.swift
//  PitchDeckMainKit
//
//  Created by Cascade on 10.02.2026.
//

import SwiftUI
import PhotosUI
import PitchDeckUIKit
import PitchDeckMainApiKit

struct EditStartupScreen: View {
    
    // MARK: - Private properties
    
    @ObservedObject private var viewModel: EditStartupViewModel
    @State private var isImagePickerPresented = false
    @State private var selectedImage: PhotosPickerItem? = nil
    let onStartupUpdated: () -> Void
    
    // MARK: - Init
    
    public init(viewModel: EditStartupViewModel, onStartupUpdated: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onStartupUpdated = onStartupUpdated
    }
    
    // MARK: - Body
    
    var body: some View {
        content
            .onAppear {
                viewModel.send(event: .onAppear)
            }
            .onChange(of: selectedImage) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        viewModel.send(event: .onSelectImage(data))
                    }
                }
            }
            .onChange(of: viewModel.didUpdateStartup) { didUpdate in
                if didUpdate {
                    onStartupUpdated()
                }
            }
            .overlay {
                if viewModel.isUpdating {
                    LoadingView()
                }
            }
    }
    
    // MARK: - Private views
    
    @ViewBuilder
    private var content: some View {
        ScrollView {
            VStack(spacing: 24) {
                imageSection
                basicFieldsSection
                categorySection
                updateButtonSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .navigationTitle("edit.startup.title".localized)
        .navigationBarTitleDisplayMode(.large)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .photosPicker(
            isPresented: $isImagePickerPresented,
            selection: $selectedImage,
            matching: .images,
            photoLibrary: .shared()
        )
    }
    
    private var imageSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("edit.startup.image.title".localized)
                .font(.headline)
                .fontWeight(.semibold)
            
            Button(action: {
                isImagePickerPresented = true
            }) {
                ZStack {
                    if let imageData = viewModel.selectedImageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                VStack {
                                    Image(systemName: "camera")
                                        .font(.largeTitle)
                                        .foregroundColor(.gray)
                                        .padding(.bottom, 16)
                                    Text("edit.startup.image.placeholder".localized)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            )
                    }
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }
    
    private var basicFieldsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("edit.startup.basic.title".localized)
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 16) {
                BasicTextField(
                    title: "edit.startup.title.placeholder".localized,
                    fieldName: "",
                    fieldValue: $viewModel.title
                )
                
                BasicTextField(
                    title: "edit.startup.description.placeholder".localized,
                    fieldName: "",
                    fieldValue: $viewModel.description
                )
                
                BasicTextField(
                    title: "edit.startup.location.placeholder".localized,
                    fieldName: "",
                    fieldValue: $viewModel.location
                )
            }
        }
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("edit.startup.category.title".localized)
                .font(.headline)
                .fontWeight(.semibold)
            
            Menu {
                ForEach(viewModel.categories, id: \.documentId) { category in
                    Button(action: {
                        viewModel.selectedCategoryId = String(category.documentId)
                    }) {
                        HStack {
                            Text(category.title)
                            Spacer()
                            if viewModel.selectedCategoryId == String(category.documentId) {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.categories.first { $0.documentId == viewModel.selectedCategoryId }?.title ?? "edit.startup.category.placeholder".localized)
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(8)
            }
        }
    }
    
    private var updateButtonSection: some View {
        VStack(spacing: 16) {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            
            PrimaryButton("edit.startup.button.title".localized) {
                viewModel.send(event: .onUpdate)
            }
            .disabled(!viewModel.isUpdateEnabled || viewModel.isUpdating)
        }
    }
}
