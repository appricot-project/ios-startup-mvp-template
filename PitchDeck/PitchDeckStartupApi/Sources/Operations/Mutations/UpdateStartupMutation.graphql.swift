// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

public struct UpdateStartupMutation: GraphQLMutation {
  public static let operationName: String = "UpdateStartup"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation UpdateStartup($documentId: ID!, $title: String!, $description: String!, $location: String!, $categoryId: ID!, $ImageURL: ID) { updateStartup( documentId: $documentId data: { title: $title description: $description location: $location category: $categoryId ImageURL: $ImageURL } ) { __typename documentId title description location createdAt updatedAt publishedAt category { __typename title categoryId } ImageURL { __typename url } ownerEmail } }"#
    ))

  public var documentId: ID
  public var title: String
  public var description: String
  public var location: String
  public var categoryId: ID
  public var imageURL: GraphQLNullable<ID>

  public init(
    documentId: ID,
    title: String,
    description: String,
    location: String,
    categoryId: ID,
    imageURL: GraphQLNullable<ID>
  ) {
    self.documentId = documentId
    self.title = title
    self.description = description
    self.location = location
    self.categoryId = categoryId
    self.imageURL = imageURL
  }

  @_spi(Unsafe) public var __variables: Variables? { [
    "documentId": documentId,
    "title": title,
    "description": description,
    "location": location,
    "categoryId": categoryId,
    "ImageURL": imageURL
  ] }

  public struct Data: PitchDeckStartupApi.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { PitchDeckStartupApi.Objects.Mutation }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("updateStartup", UpdateStartup?.self, arguments: [
        "documentId": .variable("documentId"),
        "data": [
          "title": .variable("title"),
          "description": .variable("description"),
          "location": .variable("location"),
          "category": .variable("categoryId"),
          "ImageURL": .variable("ImageURL")
        ]
      ]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      UpdateStartupMutation.Data.self
    ] }

    public var updateStartup: UpdateStartup? { __data["updateStartup"] }

    /// UpdateStartup
    ///
    /// Parent Type: `Startup`
    public struct UpdateStartup: PitchDeckStartupApi.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { PitchDeckStartupApi.Objects.Startup }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("documentId", PitchDeckStartupApi.ID.self),
        .field("title", String?.self),
        .field("description", String?.self),
        .field("location", String?.self),
        .field("createdAt", PitchDeckStartupApi.DateTime?.self),
        .field("updatedAt", PitchDeckStartupApi.DateTime?.self),
        .field("publishedAt", PitchDeckStartupApi.DateTime?.self),
        .field("category", Category?.self),
        .field("ImageURL", ImageURL?.self),
        .field("ownerEmail", String?.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        UpdateStartupMutation.Data.UpdateStartup.self
      ] }

      public var documentId: PitchDeckStartupApi.ID { __data["documentId"] }
      public var title: String? { __data["title"] }
      public var description: String? { __data["description"] }
      public var location: String? { __data["location"] }
      public var createdAt: PitchDeckStartupApi.DateTime? { __data["createdAt"] }
      public var updatedAt: PitchDeckStartupApi.DateTime? { __data["updatedAt"] }
      public var publishedAt: PitchDeckStartupApi.DateTime? { __data["publishedAt"] }
      public var category: Category? { __data["category"] }
      public var imageURL: ImageURL? { __data["ImageURL"] }
      public var ownerEmail: String? { __data["ownerEmail"] }

      /// UpdateStartup.Category
      ///
      /// Parent Type: `StartupCategory`
      public struct Category: PitchDeckStartupApi.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { PitchDeckStartupApi.Objects.StartupCategory }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("title", String?.self),
          .field("categoryId", Int?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          UpdateStartupMutation.Data.UpdateStartup.Category.self
        ] }

        public var title: String? { __data["title"] }
        public var categoryId: Int? { __data["categoryId"] }
      }

      /// UpdateStartup.ImageURL
      ///
      /// Parent Type: `UploadFile`
      public struct ImageURL: PitchDeckStartupApi.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { PitchDeckStartupApi.Objects.UploadFile }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("url", String.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          UpdateStartupMutation.Data.UpdateStartup.ImageURL.self
        ] }

        public var url: String { __data["url"] }
      }
    }
  }
}
