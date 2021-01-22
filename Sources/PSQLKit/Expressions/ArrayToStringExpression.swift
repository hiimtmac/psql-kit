import Foundation
import SQLKit
import PostgresKit

public struct ArrayToStringExpression<Content>: AggregateExpression where
    Content: PSQLArrayRepresentable
{
    let content: Content
    let delimiter: String
    let ifNull: String?
    
    public init(_ content: Content, delimiter: String, ifNull: String? = nil) {
        self.content = content
        self.delimiter = delimiter
        self.ifNull = ifNull
    }
}

extension ArrayToStringExpression: SelectSQLExpression where
    Content: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(content: content, delimiter: delimiter, ifNull: ifNull)
    }
    
    private struct _Select: SQLExpression {
        let content: Content
        let delimiter: String
        let ifNull: String?
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_TO_STRING")
            serializer.write("(")
            content.selectSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            delimiter.serialize(to: &serializer)
            if let ifNull = ifNull {
                serializer.writeComma()
                serializer.writeSpace()
                ifNull.serialize(to: &serializer)
            }
            serializer.write(")")
            serializer.write("::")
            PostgresColumnType.text.serialize(to: &serializer)
        }
    }
}

extension ArrayToStringExpression: CompareSQLExpression where
    Content: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(content: content, delimiter: delimiter, ifNull: ifNull)
    }
    
    private struct _Compare: SQLExpression {
        let content: Content
        let delimiter: String
        let ifNull: String?
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_TO_STRING")
            serializer.write("(")
            content.compareSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            delimiter.serialize(to: &serializer)
            if let ifNull = ifNull {
                serializer.writeComma()
                serializer.writeSpace()
                ifNull.serialize(to: &serializer)
            }
            serializer.write(")")
        }
    }
}

extension ArrayToStringExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = String
}

extension ArrayToStringExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArrayToStringExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
