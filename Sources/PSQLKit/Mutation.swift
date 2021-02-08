import Foundation

public struct Mutation<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType == U.CompareType
{
    let column: T
    let value: U
}

extension Mutation: InsertSQLExpression where
    T: MutationSQLExpression,
    U: MutationSQLExpression
{
    public var insertColumnSqlExpression: some SQLExpression {
        column.mutationSqlExpression
    }

    public var insertValueSqlExpression: some SQLExpression {
        value.mutationSqlExpression
    }
}
