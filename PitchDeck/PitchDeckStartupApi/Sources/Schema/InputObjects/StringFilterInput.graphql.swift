// @generated
// This file was automatically generated and should not be edited.

@_spi(Internal) @_spi(Unsafe) import ApolloAPI

public struct StringFilterInput: InputObject {
  @_spi(Unsafe) public private(set) var __data: InputDict

  @_spi(Unsafe) public init(_ data: InputDict) {
    __data = data
  }

  public init(
    and: GraphQLNullable<[String?]> = nil,
    or: GraphQLNullable<[String?]> = nil,
    not: GraphQLNullable<StringFilterInput> = nil,
    eq: GraphQLNullable<String> = nil,
    eqi: GraphQLNullable<String> = nil,
    ne: GraphQLNullable<String> = nil,
    nei: GraphQLNullable<String> = nil,
    startsWith: GraphQLNullable<String> = nil,
    endsWith: GraphQLNullable<String> = nil,
    contains: GraphQLNullable<String> = nil,
    notContains: GraphQLNullable<String> = nil,
    containsi: GraphQLNullable<String> = nil,
    notContainsi: GraphQLNullable<String> = nil,
    gt: GraphQLNullable<String> = nil,
    gte: GraphQLNullable<String> = nil,
    lt: GraphQLNullable<String> = nil,
    lte: GraphQLNullable<String> = nil,
    null: GraphQLNullable<Bool> = nil,
    notNull: GraphQLNullable<Bool> = nil,
    `in`: GraphQLNullable<[String?]> = nil,
    notIn: GraphQLNullable<[String?]> = nil,
    between: GraphQLNullable<[String?]> = nil
  ) {
    __data = InputDict([
      "and": and,
      "or": or,
      "not": not,
      "eq": eq,
      "eqi": eqi,
      "ne": ne,
      "nei": nei,
      "startsWith": startsWith,
      "endsWith": endsWith,
      "contains": contains,
      "notContains": notContains,
      "containsi": containsi,
      "notContainsi": notContainsi,
      "gt": gt,
      "gte": gte,
      "lt": lt,
      "lte": lte,
      "null": null,
      "notNull": notNull,
      "in": `in`,
      "notIn": notIn,
      "between": between
    ])
  }

  public var and: GraphQLNullable<[String?]> {
    get { __data["and"] }
    set { __data["and"] = newValue }
  }

  public var or: GraphQLNullable<[String?]> {
    get { __data["or"] }
    set { __data["or"] = newValue }
  }

  public var not: GraphQLNullable<StringFilterInput> {
    get { __data["not"] }
    set { __data["not"] = newValue }
  }

  public var eq: GraphQLNullable<String> {
    get { __data["eq"] }
    set { __data["eq"] = newValue }
  }

  public var eqi: GraphQLNullable<String> {
    get { __data["eqi"] }
    set { __data["eqi"] = newValue }
  }

  public var ne: GraphQLNullable<String> {
    get { __data["ne"] }
    set { __data["ne"] = newValue }
  }

  public var nei: GraphQLNullable<String> {
    get { __data["nei"] }
    set { __data["nei"] = newValue }
  }

  public var startsWith: GraphQLNullable<String> {
    get { __data["startsWith"] }
    set { __data["startsWith"] = newValue }
  }

  public var endsWith: GraphQLNullable<String> {
    get { __data["endsWith"] }
    set { __data["endsWith"] = newValue }
  }

  public var contains: GraphQLNullable<String> {
    get { __data["contains"] }
    set { __data["contains"] = newValue }
  }

  public var notContains: GraphQLNullable<String> {
    get { __data["notContains"] }
    set { __data["notContains"] = newValue }
  }

  public var containsi: GraphQLNullable<String> {
    get { __data["containsi"] }
    set { __data["containsi"] = newValue }
  }

  public var notContainsi: GraphQLNullable<String> {
    get { __data["notContainsi"] }
    set { __data["notContainsi"] = newValue }
  }

  public var gt: GraphQLNullable<String> {
    get { __data["gt"] }
    set { __data["gt"] = newValue }
  }

  public var gte: GraphQLNullable<String> {
    get { __data["gte"] }
    set { __data["gte"] = newValue }
  }

  public var lt: GraphQLNullable<String> {
    get { __data["lt"] }
    set { __data["lt"] = newValue }
  }

  public var lte: GraphQLNullable<String> {
    get { __data["lte"] }
    set { __data["lte"] = newValue }
  }

  public var null: GraphQLNullable<Bool> {
    get { __data["null"] }
    set { __data["null"] = newValue }
  }

  public var notNull: GraphQLNullable<Bool> {
    get { __data["notNull"] }
    set { __data["notNull"] = newValue }
  }

  public var `in`: GraphQLNullable<[String?]> {
    get { __data["in"] }
    set { __data["in"] = newValue }
  }

  public var notIn: GraphQLNullable<[String?]> {
    get { __data["notIn"] }
    set { __data["notIn"] = newValue }
  }

  public var between: GraphQLNullable<[String?]> {
    get { __data["between"] }
    set { __data["between"] = newValue }
  }
}
