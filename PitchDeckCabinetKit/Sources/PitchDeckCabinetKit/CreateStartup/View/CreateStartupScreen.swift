//
//  CreateStartupScreen.swift
//  PitchDeckCabinetKit
//
//  Created by Anton Redkozubov on 03.02.2026.
//

import SwiftUI
import PhotosUI
import PitchDeckUIKit

public struct CreateStartupScreen: View {
    
    @ObservedObject private var viewModel: CreateStartupViewModel
    public let onStartupCreated: () -> Void
    
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImage: PhotosPickerItem?
    
    public init(viewModel: CreateStartupViewModel, onStartupCreated: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onStartupCreated = onStartupCreated
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    imageSection
                    basicFieldsSection
                    categorySection
                    createButtonSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .navigationTitle("create.startup.title".localized)
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                viewModel.send(event: .onAppear)
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .photosPicker(
                isPresented: $isImagePickerPresented,
                selection: $selectedImage,
                matching: .images,
                photoLibrary: .shared()
            )
            .onChange(of: selectedImage) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        viewModel.send(event: .selectImage(data))
                    }
                }
            }
            .onChange(of: viewModel.didCreateStartup) { didCreate in
                if didCreate {
                    onStartupCreated()
                }
            }
            .overlay {
                if viewModel.isCreating {
                    LoadingView()
                }
            }
        }
    }
    
    // MARK: - Private views
    
    private var imageSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("create.startup.image.title".localized)
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
                                    Text("create.startup.image.placeholder".localized)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            )
                    }
                }
                .frame(height: 200)
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var basicFieldsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("create.startup.basic.title".localized)
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 16) {
                BasicTextField(
                    title: "create.startup.ownerEmail".localized,
                    fieldName: "",
                    fieldValue: $viewModel.ownerEmail
                )
                .onChange(of: viewModel.ownerEmail) { newValue in
                    viewModel.send(event: .ownerEmailChanged(newValue))
                }
                
                BasicTextField(
                    title: "create.startup.title".localized,
                    fieldName: "",
                    fieldValue: $viewModel.title
                )
                .onChange(of: viewModel.title) { newValue in
                    viewModel.send(event: .titleChanged(newValue))
                }
                
                BasicTextField(
                    title: "create.startup.description".localized,
                    fieldName: "",
                    fieldValue: $viewModel.description
                )
                .onChange(of: viewModel.description) { newValue in
                    viewModel.send(event: .descriptionChanged(newValue))
                }
                
                BasicTextField(
                    title: "create.startup.location".localized,
                    fieldName: "",
                    fieldValue: $viewModel.location
                )
                .onChange(of: viewModel.location) { newValue in
                    viewModel.send(event: .locationChanged(newValue))
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("create.startup.category.title".localized)
                .font(.headline)
                .fontWeight(.semibold)
            
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(8)
            } else {
                Menu {
                    ForEach(viewModel.categories) { category in
                        Button(action: {
                            viewModel.send(event: .categoryChanged(category.documentId))
                        }) {
                            HStack {
                                Text(category.title)
                                if viewModel.selectedCategoryId == category.documentId {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.selectedCategoryId.flatMap { id in
                            viewModel.categories.first { $0.documentId == id }?.title
                        } ?? "create.startup.category.placeholder".localized)
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var createButtonSection: some View {
        VStack(spacing: 16) {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            
            PrimaryButton("create.startup.button.title".localized) {
                viewModel.send(event: .createStartup)
            }
            .disabled(!viewModel.isCreateEnabled || viewModel.isCreating)
        }
    }
}
