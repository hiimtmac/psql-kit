import Foundation
import SQLKit
import PostgresKit

public struct ArrayConcatenateExpression<T, U>: AggregateExpression where
    T: PSQLArrayRepresentable & TypeEquatable,
    U: PSQLArrayRepresentable & TypeEquatable,
    T.CompareType == U.CompareType
{
    let one: T
    let two: U
    
    public init(_ one: T, _ two: U) {
        self.one = one
        self.two = two
    }
}

extension ArrayConcatenateExpression: SelectSQLExpression where
    T: SelectSQLExpression,
    U: SelectSQLExpression,
    T.CompareType: PSQLExpression
{
    public var selectSqlExpression: SQLExpression {
        _Select(one: one, two: two)
    }
    
    private struct _Select: SQLExpression {
        let one: T
        let two: U
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_CAT")
            serializer.write("(")
            one.selectSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            two.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
            serializer.write("::")
            PostgresColumnType.array(T.CompareType.postgresColumnType).serialize(to: &serializer)
        }
    }
}

extension ArrayConcatenateExpression: CompareSQLExpression where
    T: CompareSQLExpression,
    U: CompareSQLExpression
{
    public var compareSqlExpression: SQLExpression {
        _Compare(one: one, two: two)
    }
    
    private struct _Compare: SQLExpression {
        let one: T
        let two: U
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_CAT")
            serializer.write("(")
            one.compareSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            two.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArrayConcatenateExpression: TypeEquatable where T: TypeEquatable {
    public typealias CompareType = [T.CompareType]
}

extension ArrayConcatenateExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArrayConcatenateExpression<T, U>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
