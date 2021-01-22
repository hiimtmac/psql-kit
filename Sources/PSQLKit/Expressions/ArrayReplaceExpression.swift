import Foundation
import SQLKit
import PostgresKit

public struct ArrayReplaceExpression<Content, T, U>: AggregateExpression where
    Content: PSQLArrayRepresentable & TypeEquatable,
    T: TypeEquatable,
    U: TypeEquatable,
    Content.CompareType == T.CompareType,
    T.CompareType == U.CompareType
{
    let content: Content
    let find: T
    let replace: U
    
    public init(_ content: Content, find: T, replace: U) {
        self.content = content
        self.find = find
        self.replace = replace
    }
}

extension ArrayReplaceExpression: SelectSQLExpression where
    Content: SelectSQLExpression,
    T: PSQLExpression,
    T: SelectSQLExpression,
    U: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(content: content, find: find, replace: replace)
    }
    
    private struct _Select: SQLExpression {
        let content: Content
        let find: T
        let replace: U
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_REPLACE")
            serializer.write("(")
            content.selectSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            find.selectSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            replace.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
            serializer.write("::")
            PostgresColumnType.array(T.postgresColumnType).serialize(to: &serializer)
        }
    }
}

extension ArrayReplaceExpression: CompareSQLExpression where
    Content: CompareSQLExpression,
    T: CompareSQLExpression,
    U: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(content: content, find: find, replace: replace)
    }
    
    private struct _Compare: SQLExpression {
        let content: Content
        let find: T
        let replace: U
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_REPLACE")
            serializer.write("(")
            content.compareSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            find.compareSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            replace.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArrayReplaceExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = [Content.CompareType]
}

extension ArrayReplaceExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArrayReplaceExpression<Content, T, U>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
