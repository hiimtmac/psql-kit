import Foundation
import SQLKit
import PostgresKit

public struct ArrayPrependExpression<Content, T>: AggregateExpression where
    Content: PSQLArrayRepresentable & TypeEquatable,
    T: TypeEquatable,
    Content.CompareType == T.CompareType
{
    let content: Content
    let prepend: T
    
    public init(_ content: Content, prepend: T) {
        self.content = content
        self.prepend = prepend
    }
}

extension ArrayPrependExpression: SelectSQLExpression where
    Content: SelectSQLExpression,
    T: PSQLExpression & SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(content: content, prepend: prepend)
    }
    
    private struct _Select: SQLExpression {
        let content: Content
        let prepend: T
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_PREPEND")
            serializer.write("(")
            prepend.selectSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            content.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
            serializer.write("::")
            PostgresColumnType.array(T.postgresColumnType).serialize(to: &serializer)
        }
    }
}

extension ArrayPrependExpression: CompareSQLExpression where
    Content: CompareSQLExpression,
    T: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(content: content, prepend: prepend)
    }
    
    private struct _Compare: SQLExpression {
        let content: Content
        let prepend: T
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_PREPEND")
            serializer.write("(")
            prepend.compareSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            content.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArrayPrependExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = [Content.CompareType]
}

extension ArrayPrependExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArrayPrependExpression<Content, T>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
