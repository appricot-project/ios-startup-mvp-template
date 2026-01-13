// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == PitchDeckStartupApi.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == PitchDeckStartupApi.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == PitchDeckStartupApi.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == PitchDeckStartupApi.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  @_spi(Execution) public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    switch typename {
    case "Pagination": return PitchDeckStartupApi.Objects.Pagination
    case "Query": return PitchDeckStartupApi.Objects.Query
    case "Startup": return PitchDeckStartupApi.Objects.Startup
    case "StartupCategory": return PitchDeckStartupApi.Objects.StartupCategory
    case "StartupEntityResponseCollection": return PitchDeckStartupApi.Objects.StartupEntityResponseCollection
    case "UploadFile": return PitchDeckStartupApi.Objects.UploadFile
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
