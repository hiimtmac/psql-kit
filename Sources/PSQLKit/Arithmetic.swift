import Foundation
import SQLKit
import PostgresKit

public struct ArithmeticOperator: SQLExpression {
    let value: String
    
    public init(_ value: String) {
        self.value = value
    }
    
    public static let addition = ArithmeticOperator("+")
    public static let subtraction = ArithmeticOperator("-")
    public static let multiplication = ArithmeticOperator("*")
    public static let division = ArithmeticOperator("/")
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write(value)
    }
}

public struct ArithmeticExpression<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType == U.CompareType
{
    let lhs: T
    let `operator`: ArithmeticOperator
    let rhs: U
    
    public init(lhs: T, operator: ArithmeticOperator, rhs: U) {
        self.lhs = lhs
        self.operator = `operator`
        self.rhs = rhs
    }
}

extension ArithmeticExpression: TypeEquatable {
    public typealias CompareType = T.CompareType
}

extension ArithmeticExpression: SelectSQLExpression where
    T: SelectSQLExpression,
    U: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(lhs: lhs, operator: `operator`, rhs: rhs)
    }
    
    private struct _Select: SQLExpression {
        let lhs: T
        let `operator`: ArithmeticOperator
        let rhs: U
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("(")
            lhs.selectSqlExpression.serialize(to: &serializer)
            serializer.writeSpace()
            `operator`.serialize(to: &serializer)
            serializer.writeSpace()
            rhs.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
            serializer.write("::")
            PostgresColumnType.decimal.serialize(to: &serializer)
        }
    }
}

extension ArithmeticExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArithmeticExpression<T, U>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

extension ArithmeticExpression: CompareSQLExpression where
    T: CompareSQLExpression,
    U: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(lhs: lhs, operator: `operator`, rhs: rhs)
    }
    
    private struct _Compare: SQLExpression {
        let lhs: T
        let `operator`: ArithmeticOperator
        let rhs: U
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("(")
            lhs.compareSqlExpression.serialize(to: &serializer)
            serializer.writeSpace()
            `operator`.serialize(to: &serializer)
            serializer.writeSpace()
            rhs.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArithmeticExpression: WhereSQLExpression where
    T: CompareSQLExpression,
    U: CompareSQLExpression
{
    public var whereSqlExpression: some SQLExpression {
        _Compare(lhs: lhs, operator: `operator`, rhs: rhs)
    }
}

extension ArithmeticExpression: HavingSQLExpression where
    T: CompareSQLExpression,
    U: CompareSQLExpression
{
    public var havingSqlExpression: some SQLExpression {
        _Compare(lhs: lhs, operator: `operator`, rhs: rhs)
    }
}

extension ArithmeticExpression: JoinSQLExpression where
    T: CompareSQLExpression,
    U: CompareSQLExpression
{
    public var joinSqlExpression: some SQLExpression {
        _Compare(lhs: lhs, operator: `operator`, rhs: rhs)
    }
}
