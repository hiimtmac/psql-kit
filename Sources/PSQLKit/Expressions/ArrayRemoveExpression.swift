import Foundation
import SQLKit
import PostgresKit

public struct ArrayRemoveExpression<Content, T>: AggregateExpression where
    Content: PSQLArrayRepresentable & TypeEquatable,
    T: TypeEquatable,
    Content.CompareType == T.CompareType
{
    let content: Content
    let remove: T
    
    public init(_ content: Content, remove: T) {
        self.content = content
        self.remove = remove
    }
}

extension ArrayRemoveExpression: SelectSQLExpression where
    Content: SelectSQLExpression,
    T: PSQLExpression & SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(content: content, remove: remove)
    }
    
    private struct _Select: SQLExpression {
        let content: Content
        let remove: T
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_REMOVE")
            serializer.write("(")
            content.selectSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            remove.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
            serializer.write("::")
            PostgresColumnType.array(T.postgresColumnType).serialize(to: &serializer)
        }
    }
}

extension ArrayRemoveExpression: CompareSQLExpression where
    Content: CompareSQLExpression,
    T: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(content: content, remove: remove)
    }
    
    private struct _Compare: SQLExpression {
        let content: Content
        let remove: T
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_REMOVE")
            serializer.write("(")
            content.compareSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            remove.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArrayRemoveExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = [Content.CompareType]
}

extension ArrayRemoveExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArrayRemoveExpression<Content, T>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
