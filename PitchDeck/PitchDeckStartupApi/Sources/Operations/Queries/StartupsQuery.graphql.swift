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

  public struct Data: API.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { API.Objects.Query }
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
    public struct Startup: API.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { API.Objects.Startup }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("documentId", API.ID.self),
        .field("startupId", Int?.self),
        .field("title", String?.self),
        .field("description", String?.self),
        .field("location", String?.self),
        .field("createdAt", API.DateTime?.self),
        .field("updatedAt", API.DateTime?.self),
        .field("publishedAt", API.DateTime?.self),
        .field("category", Category?.self),
        .field("ImageURL", ImageURL?.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        StartupsQuery.Data.Startup.self
      ] }

      public var documentId: API.ID { __data["documentId"] }
      public var startupId: Int? { __data["startupId"] }
      public var title: String? { __data["title"] }
      public var description: String? { __data["description"] }
      public var location: String? { __data["location"] }
      public var createdAt: API.DateTime? { __data["createdAt"] }
      public var updatedAt: API.DateTime? { __data["updatedAt"] }
      public var publishedAt: API.DateTime? { __data["publishedAt"] }
      public var category: Category? { __data["category"] }
      public var imageURL: ImageURL? { __data["ImageURL"] }

      /// Startup.Category
      ///
      /// Parent Type: `StartupCategory`
      public struct Category: API.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { API.Objects.StartupCategory }
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
      public struct ImageURL: API.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { API.Objects.UploadFile }
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
