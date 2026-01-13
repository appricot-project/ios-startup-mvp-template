// @generated
// This file was automatically generated and should not be edited.

@_spi(Internal) @_spi(Unsafe) import ApolloAPI

public struct IntFilterInput: InputObject {
  @_spi(Unsafe) public private(set) var __data: InputDict

  @_spi(Unsafe) public init(_ data: InputDict) {
    __data = data
  }

  public init(
    and: GraphQLNullable<[Int32?]> = nil,
    or: GraphQLNullable<[Int32?]> = nil,
    not: GraphQLNullable<IntFilterInput> = nil,
    eq: GraphQLNullable<Int32> = nil,
    eqi: GraphQLNullable<Int32> = nil,
    ne: GraphQLNullable<Int32> = nil,
    nei: GraphQLNullable<Int32> = nil,
    startsWith: GraphQLNullable<Int32> = nil,
    endsWith: GraphQLNullable<Int32> = nil,
    contains: GraphQLNullable<Int32> = nil,
    notContains: GraphQLNullable<Int32> = nil,
    containsi: GraphQLNullable<Int32> = nil,
    notContainsi: GraphQLNullable<Int32> = nil,
    gt: GraphQLNullable<Int32> = nil,
    gte: GraphQLNullable<Int32> = nil,
    lt: GraphQLNullable<Int32> = nil,
    lte: GraphQLNullable<Int32> = nil,
    null: GraphQLNullable<Bool> = nil,
    notNull: GraphQLNullable<Bool> = nil,
    `in`: GraphQLNullable<[Int32?]> = nil,
    notIn: GraphQLNullable<[Int32?]> = nil,
    between: GraphQLNullable<[Int32?]> = nil
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

  public var and: GraphQLNullable<[Int32?]> {
    get { __data["and"] }
    set { __data["and"] = newValue }
  }

  public var or: GraphQLNullable<[Int32?]> {
    get { __data["or"] }
    set { __data["or"] = newValue }
  }

  public var not: GraphQLNullable<IntFilterInput> {
    get { __data["not"] }
    set { __data["not"] = newValue }
  }

  public var eq: GraphQLNullable<Int32> {
    get { __data["eq"] }
    set { __data["eq"] = newValue }
  }

  public var eqi: GraphQLNullable<Int32> {
    get { __data["eqi"] }
    set { __data["eqi"] = newValue }
  }

  public var ne: GraphQLNullable<Int32> {
    get { __data["ne"] }
    set { __data["ne"] = newValue }
  }

  public var nei: GraphQLNullable<Int32> {
    get { __data["nei"] }
    set { __data["nei"] = newValue }
  }

  public var startsWith: GraphQLNullable<Int32> {
    get { __data["startsWith"] }
    set { __data["startsWith"] = newValue }
  }

  public var endsWith: GraphQLNullable<Int32> {
    get { __data["endsWith"] }
    set { __data["endsWith"] = newValue }
  }

  public var contains: GraphQLNullable<Int32> {
    get { __data["contains"] }
    set { __data["contains"] = newValue }
  }

  public var notContains: GraphQLNullable<Int32> {
    get { __data["notContains"] }
    set { __data["notContains"] = newValue }
  }

  public var containsi: GraphQLNullable<Int32> {
    get { __data["containsi"] }
    set { __data["containsi"] = newValue }
  }

  public var notContainsi: GraphQLNullable<Int32> {
    get { __data["notContainsi"] }
    set { __data["notContainsi"] = newValue }
  }

  public var gt: GraphQLNullable<Int32> {
    get { __data["gt"] }
    set { __data["gt"] = newValue }
  }

  public var gte: GraphQLNullable<Int32> {
    get { __data["gte"] }
    set { __data["gte"] = newValue }
  }

  public var lt: GraphQLNullable<Int32> {
    get { __data["lt"] }
    set { __data["lt"] = newValue }
  }

  public var lte: GraphQLNullable<Int32> {
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

  public var `in`: GraphQLNullable<[Int32?]> {
    get { __data["in"] }
    set { __data["in"] = newValue }
  }

  public var notIn: GraphQLNullable<[Int32?]> {
    get { __data["notIn"] }
    set { __data["notIn"] = newValue }
  }

  public var between: GraphQLNullable<[Int32?]> {
    get { __data["between"] }
    set { __data["between"] = newValue }
  }
}
