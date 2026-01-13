// @generated
// This file was automatically generated and should not be edited.

@_spi(Internal) @_spi(Unsafe) import ApolloAPI

public struct DateTimeFilterInput: InputObject {
  @_spi(Unsafe) public private(set) var __data: InputDict

  @_spi(Unsafe) public init(_ data: InputDict) {
    __data = data
  }

  public init(
    and: GraphQLNullable<[DateTime?]> = nil,
    or: GraphQLNullable<[DateTime?]> = nil,
    not: GraphQLNullable<DateTimeFilterInput> = nil,
    eq: GraphQLNullable<DateTime> = nil,
    eqi: GraphQLNullable<DateTime> = nil,
    ne: GraphQLNullable<DateTime> = nil,
    nei: GraphQLNullable<DateTime> = nil,
    startsWith: GraphQLNullable<DateTime> = nil,
    endsWith: GraphQLNullable<DateTime> = nil,
    contains: GraphQLNullable<DateTime> = nil,
    notContains: GraphQLNullable<DateTime> = nil,
    containsi: GraphQLNullable<DateTime> = nil,
    notContainsi: GraphQLNullable<DateTime> = nil,
    gt: GraphQLNullable<DateTime> = nil,
    gte: GraphQLNullable<DateTime> = nil,
    lt: GraphQLNullable<DateTime> = nil,
    lte: GraphQLNullable<DateTime> = nil,
    null: GraphQLNullable<Bool> = nil,
    notNull: GraphQLNullable<Bool> = nil,
    `in`: GraphQLNullable<[DateTime?]> = nil,
    notIn: GraphQLNullable<[DateTime?]> = nil,
    between: GraphQLNullable<[DateTime?]> = nil
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

  public var and: GraphQLNullable<[DateTime?]> {
    get { __data["and"] }
    set { __data["and"] = newValue }
  }

  public var or: GraphQLNullable<[DateTime?]> {
    get { __data["or"] }
    set { __data["or"] = newValue }
  }

  public var not: GraphQLNullable<DateTimeFilterInput> {
    get { __data["not"] }
    set { __data["not"] = newValue }
  }

  public var eq: GraphQLNullable<DateTime> {
    get { __data["eq"] }
    set { __data["eq"] = newValue }
  }

  public var eqi: GraphQLNullable<DateTime> {
    get { __data["eqi"] }
    set { __data["eqi"] = newValue }
  }

  public var ne: GraphQLNullable<DateTime> {
    get { __data["ne"] }
    set { __data["ne"] = newValue }
  }

  public var nei: GraphQLNullable<DateTime> {
    get { __data["nei"] }
    set { __data["nei"] = newValue }
  }

  public var startsWith: GraphQLNullable<DateTime> {
    get { __data["startsWith"] }
    set { __data["startsWith"] = newValue }
  }

  public var endsWith: GraphQLNullable<DateTime> {
    get { __data["endsWith"] }
    set { __data["endsWith"] = newValue }
  }

  public var contains: GraphQLNullable<DateTime> {
    get { __data["contains"] }
    set { __data["contains"] = newValue }
  }

  public var notContains: GraphQLNullable<DateTime> {
    get { __data["notContains"] }
    set { __data["notContains"] = newValue }
  }

  public var containsi: GraphQLNullable<DateTime> {
    get { __data["containsi"] }
    set { __data["containsi"] = newValue }
  }

  public var notContainsi: GraphQLNullable<DateTime> {
    get { __data["notContainsi"] }
    set { __data["notContainsi"] = newValue }
  }

  public var gt: GraphQLNullable<DateTime> {
    get { __data["gt"] }
    set { __data["gt"] = newValue }
  }

  public var gte: GraphQLNullable<DateTime> {
    get { __data["gte"] }
    set { __data["gte"] = newValue }
  }

  public var lt: GraphQLNullable<DateTime> {
    get { __data["lt"] }
    set { __data["lt"] = newValue }
  }

  public var lte: GraphQLNullable<DateTime> {
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

  public var `in`: GraphQLNullable<[DateTime?]> {
    get { __data["in"] }
    set { __data["in"] = newValue }
  }

  public var notIn: GraphQLNullable<[DateTime?]> {
    get { __data["notIn"] }
    set { __data["notIn"] = newValue }
  }

  public var between: GraphQLNullable<[DateTime?]> {
    get { __data["between"] }
    set { __data["between"] = newValue }
  }
}
