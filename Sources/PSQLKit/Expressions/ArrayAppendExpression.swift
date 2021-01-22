import Foundation
import SQLKit
import PostgresKit

public struct ArrayAppendExpression<Content, T>: AggregateExpression where
    Content: PSQLArrayRepresentable & TypeEquatable,
    T: TypeEquatable,
    Content.CompareType == T.CompareType
{
    let content: Content
    let append: T
    
    public init(_ content: Content, append: T) {
        self.content = content
        self.append = append
    }
}

extension ArrayAppendExpression: SelectSQLExpression where
    Content: SelectSQLExpression,
    T: PSQLExpression & SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(content: content, append: append)
    }
    
    private struct _Select: SQLExpression {
        let content: Content
        let append: T
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_APPEND")
            serializer.write("(")
            content.selectSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            append.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
            serializer.write("::")
            PostgresColumnType.array(T.postgresColumnType).serialize(to: &serializer)
        }
    }
}

extension ArrayAppendExpression: CompareSQLExpression where
    Content: CompareSQLExpression,
    T: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(content: content, append: append)
    }
    
    private struct _Compare: SQLExpression {
        let content: Content
        let append: T
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_APPEND")
            serializer.write("(")
            content.compareSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            append.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArrayAppendExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = [Content.CompareType]
}

extension ArrayAppendExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArrayAppendExpression<Content, T>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
