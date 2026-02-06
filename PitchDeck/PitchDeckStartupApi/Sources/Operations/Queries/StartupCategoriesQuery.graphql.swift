// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

public struct StartupCategoriesQuery: GraphQLQuery {
  public static let operationName: String = "StartupCategories"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query StartupCategories { startupCategories { __typename documentId title categoryId } }"#
    ))

  public init() {}

  public struct Data: PitchDeckStartupApi.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { PitchDeckStartupApi.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("startupCategories", [StartupCategory?].self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      StartupCategoriesQuery.Data.self
    ] }

    public var startupCategories: [StartupCategory?] { __data["startupCategories"] }

    /// StartupCategory
    ///
    /// Parent Type: `StartupCategory`
    public struct StartupCategory: PitchDeckStartupApi.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { PitchDeckStartupApi.Objects.StartupCategory }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("documentId", PitchDeckStartupApi.ID.self),
        .field("title", String?.self),
        .field("categoryId", Int?.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        StartupCategoriesQuery.Data.StartupCategory.self
      ] }

      public var documentId: PitchDeckStartupApi.ID { __data["documentId"] }
      public var title: String? { __data["title"] }
      public var categoryId: Int? { __data["categoryId"] }
    }
  }
}
