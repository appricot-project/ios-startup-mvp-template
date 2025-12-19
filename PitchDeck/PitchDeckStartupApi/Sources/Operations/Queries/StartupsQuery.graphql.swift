// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

public struct StartupsQuery: GraphQLQuery {
  public static let operationName: String = "Startups"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Startups { startups { __typename documentId startupId title description location createdAt updatedAt publishedAt category { __typename title categoryId } ImageURL { __typename url } } }"#
    ))

  public init() {}

  public struct Data: PitchDeckStartupApi.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { PitchDeckStartupApi.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("startups", [Startup?].self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      StartupsQuery.Data.self
    ] }

    public var startups: [Startup?] { __data["startups"] }

    /// Startup
    ///
    /// Parent Type: `Startup`
    public struct Startup: PitchDeckStartupApi.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { PitchDeckStartupApi.Objects.Startup }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("documentId", PitchDeckStartupApi.ID.self),
        .field("startupId", Int?.self),
        .field("title", String?.self),
        .field("description", String?.self),
        .field("location", String?.self),
        .field("createdAt", PitchDeckStartupApi.DateTime?.self),
        .field("updatedAt", PitchDeckStartupApi.DateTime?.self),
        .field("publishedAt", PitchDeckStartupApi.DateTime?.self),
        .field("category", Category?.self),
        .field("ImageURL", ImageURL?.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        StartupsQuery.Data.Startup.self
      ] }

      public var documentId: PitchDeckStartupApi.ID { __data["documentId"] }
      public var startupId: Int? { __data["startupId"] }
      public var title: String? { __data["title"] }
      public var description: String? { __data["description"] }
      public var location: String? { __data["location"] }
      public var createdAt: PitchDeckStartupApi.DateTime? { __data["createdAt"] }
      public var updatedAt: PitchDeckStartupApi.DateTime? { __data["updatedAt"] }
      public var publishedAt: PitchDeckStartupApi.DateTime? { __data["publishedAt"] }
      public var category: Category? { __data["category"] }
      public var imageURL: ImageURL? { __data["ImageURL"] }

      /// Startup.Category
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
          StartupsQuery.Data.Startup.Category.self
        ] }

        public var title: String? { __data["title"] }
        public var categoryId: Int? { __data["categoryId"] }
      }

      /// Startup.ImageURL
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
          StartupsQuery.Data.Startup.ImageURL.self
        ] }

        public var url: String { __data["url"] }
      }
    }
  }
}
