// @generated
// This file was automatically generated and should not be edited.

@_spi(Internal) @_spi(Unsafe) import ApolloAPI

public struct StartupFiltersInput: InputObject {
  @_spi(Unsafe) public private(set) var __data: InputDict

  @_spi(Unsafe) public init(_ data: InputDict) {
    __data = data
  }

  public init(
    documentId: GraphQLNullable<IDFilterInput> = nil,
    title: GraphQLNullable<StringFilterInput> = nil,
    description: GraphQLNullable<StringFilterInput> = nil,
    location: GraphQLNullable<StringFilterInput> = nil,
    category: GraphQLNullable<StartupCategoryFiltersInput> = nil,
    ownerEmail: GraphQLNullable<StringFilterInput> = nil,
    createdAt: GraphQLNullable<DateTimeFilterInput> = nil,
    updatedAt: GraphQLNullable<DateTimeFilterInput> = nil,
    publishedAt: GraphQLNullable<DateTimeFilterInput> = nil,
    and: GraphQLNullable<[StartupFiltersInput?]> = nil,
    or: GraphQLNullable<[StartupFiltersInput?]> = nil,
    not: GraphQLNullable<StartupFiltersInput> = nil
  ) {
    __data = InputDict([
      "documentId": documentId,
      "title": title,
      "description": description,
      "location": location,
      "category": category,
      "ownerEmail": ownerEmail,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "publishedAt": publishedAt,
      "and": and,
      "or": or,
      "not": not
    ])
  }

  public var documentId: GraphQLNullable<IDFilterInput> {
    get { __data["documentId"] }
    set { __data["documentId"] = newValue }
  }

  public var title: GraphQLNullable<StringFilterInput> {
    get { __data["title"] }
    set { __data["title"] = newValue }
  }

  public var description: GraphQLNullable<StringFilterInput> {
    get { __data["description"] }
    set { __data["description"] = newValue }
  }

  public var location: GraphQLNullable<StringFilterInput> {
    get { __data["location"] }
    set { __data["location"] = newValue }
  }

  public var category: GraphQLNullable<StartupCategoryFiltersInput> {
    get { __data["category"] }
    set { __data["category"] = newValue }
  }

  public var ownerEmail: GraphQLNullable<StringFilterInput> {
    get { __data["ownerEmail"] }
    set { __data["ownerEmail"] = newValue }
  }

  public var createdAt: GraphQLNullable<DateTimeFilterInput> {
    get { __data["createdAt"] }
    set { __data["createdAt"] = newValue }
  }

  public var updatedAt: GraphQLNullable<DateTimeFilterInput> {
    get { __data["updatedAt"] }
    set { __data["updatedAt"] = newValue }
  }

  public var publishedAt: GraphQLNullable<DateTimeFilterInput> {
    get { __data["publishedAt"] }
    set { __data["publishedAt"] = newValue }
  }

  public var and: GraphQLNullable<[StartupFiltersInput?]> {
    get { __data["and"] }
    set { __data["and"] = newValue }
  }

  public var or: GraphQLNullable<[StartupFiltersInput?]> {
    get { __data["or"] }
    set { __data["or"] = newValue }
  }

  public var not: GraphQLNullable<StartupFiltersInput> {
    get { __data["not"] }
    set { __data["not"] = newValue }
  }
}
