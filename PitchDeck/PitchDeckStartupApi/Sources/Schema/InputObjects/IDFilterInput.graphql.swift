// @generated
// This file was automatically generated and should not be edited.

@_spi(Internal) @_spi(Unsafe) import ApolloAPI

public struct IDFilterInput: InputObject {
  @_spi(Unsafe) public private(set) var __data: InputDict

  @_spi(Unsafe) public init(_ data: InputDict) {
    __data = data
  }

  public init(
    and: GraphQLNullable<[ID?]> = nil,
    or: GraphQLNullable<[ID?]> = nil,
    not: GraphQLNullable<IDFilterInput> = nil,
    eq: GraphQLNullable<ID> = nil,
    eqi: GraphQLNullable<ID> = nil,
    ne: GraphQLNullable<ID> = nil,
    nei: GraphQLNullable<ID> = nil,
    startsWith: GraphQLNullable<ID> = nil,
    endsWith: GraphQLNullable<ID> = nil,
    contains: GraphQLNullable<ID> = nil,
    notContains: GraphQLNullable<ID> = nil,
    containsi: GraphQLNullable<ID> = nil,
    notContainsi: GraphQLNullable<ID> = nil,
    gt: GraphQLNullable<ID> = nil,
    gte: GraphQLNullable<ID> = nil,
    lt: GraphQLNullable<ID> = nil,
    lte: GraphQLNullable<ID> = nil,
    null: GraphQLNullable<Bool> = nil,
    notNull: GraphQLNullable<Bool> = nil,
    `in`: GraphQLNullable<[ID?]> = nil,
    notIn: GraphQLNullable<[ID?]> = nil,
    between: GraphQLNullable<[ID?]> = nil
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

  public var and: GraphQLNullable<[ID?]> {
    get { __data["and"] }
    set { __data["and"] = newValue }
  }

  public var or: GraphQLNullable<[ID?]> {
    get { __data["or"] }
    set { __data["or"] = newValue }
  }

  public var not: GraphQLNullable<IDFilterInput> {
    get { __data["not"] }
    set { __data["not"] = newValue }
  }

  public var eq: GraphQLNullable<ID> {
    get { __data["eq"] }
    set { __data["eq"] = newValue }
  }

  public var eqi: GraphQLNullable<ID> {
    get { __data["eqi"] }
    set { __data["eqi"] = newValue }
  }

  public var ne: GraphQLNullable<ID> {
    get { __data["ne"] }
    set { __data["ne"] = newValue }
  }

  public var nei: GraphQLNullable<ID> {
    get { __data["nei"] }
    set { __data["nei"] = newValue }
  }

  public var startsWith: GraphQLNullable<ID> {
    get { __data["startsWith"] }
    set { __data["startsWith"] = newValue }
  }

  public var endsWith: GraphQLNullable<ID> {
    get { __data["endsWith"] }
    set { __data["endsWith"] = newValue }
  }

  public var contains: GraphQLNullable<ID> {
    get { __data["contains"] }
    set { __data["contains"] = newValue }
  }

  public var notContains: GraphQLNullable<ID> {
    get { __data["notContains"] }
    set { __data["notContains"] = newValue }
  }

  public var containsi: GraphQLNullable<ID> {
    get { __data["containsi"] }
    set { __data["containsi"] = newValue }
  }

  public var notContainsi: GraphQLNullable<ID> {
    get { __data["notContainsi"] }
    set { __data["notContainsi"] = newValue }
  }

  public var gt: GraphQLNullable<ID> {
    get { __data["gt"] }
    set { __data["gt"] = newValue }
  }

  public var gte: GraphQLNullable<ID> {
    get { __data["gte"] }
    set { __data["gte"] = newValue }
  }

  public var lt: GraphQLNullable<ID> {
    get { __data["lt"] }
    set { __data["lt"] = newValue }
  }

  public var lte: GraphQLNullable<ID> {
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

  public var `in`: GraphQLNullable<[ID?]> {
    get { __data["in"] }
    set { __data["in"] = newValue }
  }

  public var notIn: GraphQLNullable<[ID?]> {
    get { __data["notIn"] }
    set { __data["notIn"] = newValue }
  }

  public var between: GraphQLNullable<[ID?]> {
    get { __data["between"] }
    set { __data["between"] = newValue }
  }
}
