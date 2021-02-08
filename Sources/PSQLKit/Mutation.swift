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

extension Mutation: UpdateSQLExpression where
    T: MutationSQLExpression,
    U: MutationSQLExpression
{
    private struct _Update: SQLExpression {
        let column: T
        let value: U

        func serialize(to serializer: inout SQLSerializer) {
            column.mutationSqlExpression.serialize(to: &serializer)
            serializer.writeSpace()
            serializer.write("=")
            serializer.writeSpace()
            value.mutationSqlExpression.serialize(to: &serializer)
        }
    }

    public var updateSqlExpression: some SQLExpression {
        _Update(column: column, value: value)
    }
}
