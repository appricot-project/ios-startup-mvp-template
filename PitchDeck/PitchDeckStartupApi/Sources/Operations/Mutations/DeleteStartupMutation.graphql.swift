// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

public struct DeleteStartupMutation: GraphQLMutation {
  public static let operationName: String = "DeleteStartup"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation DeleteStartup($documentId: ID!) { deleteStartup(documentId: $documentId) { __typename documentId } }"#
    ))

  public var documentId: ID

  public init(documentId: ID) {
    self.documentId = documentId
  }

  @_spi(Unsafe) public var __variables: Variables? { ["documentId": documentId] }

  public struct Data: PitchDeckStartupApi.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { PitchDeckStartupApi.Objects.Mutation }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("deleteStartup", DeleteStartup?.self, arguments: ["documentId": .variable("documentId")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      DeleteStartupMutation.Data.self
    ] }

    public var deleteStartup: DeleteStartup? { __data["deleteStartup"] }

    /// DeleteStartup
    ///
    /// Parent Type: `DeleteMutationResponse`
    public struct DeleteStartup: PitchDeckStartupApi.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { PitchDeckStartupApi.Objects.DeleteMutationResponse }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("documentId", PitchDeckStartupApi.ID.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        DeleteStartupMutation.Data.DeleteStartup.self
      ] }

      public var documentId: PitchDeckStartupApi.ID { __data["documentId"] }
    }
  }
}
