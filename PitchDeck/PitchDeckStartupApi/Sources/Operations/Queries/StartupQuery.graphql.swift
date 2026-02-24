// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

public struct StartupQuery: GraphQLQuery {
  public static let operationName: String = "Startup"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Startup($documentId: ID!) { startup(documentId: $documentId) { __typename documentId ownerEmail title description location createdAt updatedAt publishedAt ImageURL { __typename url } category { __typename title } } }"#
    ))

  public var documentId: ID

  public init(documentId: ID) {
    self.documentId = documentId
  }

  @_spi(Unsafe) public var __variables: Variables? { ["documentId": documentId] }

  public struct Data: PitchDeckStartupApi.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { PitchDeckStartupApi.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("startup", Startup?.self, arguments: ["documentId": .variable("documentId")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      StartupQuery.Data.self
    ] }

    public var startup: Startup? { __data["startup"] }

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
        .field("ownerEmail", String?.self),
        .field("title", String?.self),
        .field("description", String?.self),
        .field("location", String?.self),
        .field("createdAt", PitchDeckStartupApi.DateTime?.self),
        .field("updatedAt", PitchDeckStartupApi.DateTime?.self),
        .field("publishedAt", PitchDeckStartupApi.DateTime?.self),
        .field("ImageURL", ImageURL?.self),
        .field("category", Category?.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        StartupQuery.Data.Startup.self
      ] }

      public var documentId: PitchDeckStartupApi.ID { __data["documentId"] }
      public var ownerEmail: String? { __data["ownerEmail"] }
      public var title: String? { __data["title"] }
      public var description: String? { __data["description"] }
      public var location: String? { __data["location"] }
      public var createdAt: PitchDeckStartupApi.DateTime? { __data["createdAt"] }
      public var updatedAt: PitchDeckStartupApi.DateTime? { __data["updatedAt"] }
      public var publishedAt: PitchDeckStartupApi.DateTime? { __data["publishedAt"] }
      public var imageURL: ImageURL? { __data["ImageURL"] }
      public var category: Category? { __data["category"] }

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
          StartupQuery.Data.Startup.ImageURL.self
        ] }

        public var url: String { __data["url"] }
      }

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
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          StartupQuery.Data.Startup.Category.self
        ] }

        public var title: String? { __data["title"] }
      }
    }
  }
}
