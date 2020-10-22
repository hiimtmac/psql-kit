import Foundation
import SQLKit

public struct JsonExtractPathTextExpression<Content>: SQLExpression where Content: SelectSQLExpressible {
    let content: Content
    let pathElements: [String]
    
    public init(_ content: Content, _ paths: String...) {
        self.content = content
        self.pathElements = paths
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("JSON_EXTRACT_PATH_TEXT")
        serializer.write("(")
        content.selectSqlExpression.serialize(to: &serializer)
        serializer.write(",")
        serializer.writeSpace()
        SQLList(pathElements).serialize(to: &serializer)
        serializer.write(")")
    }
}

extension JsonExtractPathTextExpression: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { self }
}

extension JsonExtractPathTextExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<JsonExtractPathTextExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

extension JsonExtractPathTextExpression: TypeEquatable {
    public typealias CompareType = Self
}

public struct JsonbExtractPathTextExpression<Content>: SQLExpression where Content: SelectSQLExpressible {
    let content: Content
    let pathElements: [String]
    
    public init(_ content: Content, _ paths: String...) {
        self.content = content
        self.pathElements = paths
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("JSONB_EXTRACT_PATH_TEXT")
        serializer.write("(")
        content.selectSqlExpression.serialize(to: &serializer)
        serializer.write(",")
        serializer.writeSpace()
        SQLList(pathElements).serialize(to: &serializer)
        serializer.write(")")
    }
}

extension JsonbExtractPathTextExpression: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { self }
}

extension JsonbExtractPathTextExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<JsonbExtractPathTextExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

extension JsonbExtractPathTextExpression: TypeEquatable {
    public typealias CompareType = Self
}
