import Foundation

func ==<T, U>(_ lhs: T, _ rhs: U) -> CompareExpression<T, U> {
    CompareExpression(lhs: lhs, operator: .equal, rhs: rhs)
}

func !=<T, U>(_ lhs: T, _ rhs: U) -> CompareExpression<T, U> {
    CompareExpression(lhs: lhs, operator: .notEqual, rhs: rhs)
}

infix operator ><: LogicalConjunctionPrecedence
func ><<T, U>(_ lhs: T, _ rhs: U) -> CompareExpression<T, U> {
    CompareExpression(lhs: lhs, operator: .in, rhs: rhs)
}

infix operator <>: LogicalConjunctionPrecedence
func <><T, U>(_ lhs: T, _ rhs: U) -> CompareExpression<T, U> {
    CompareExpression(lhs: lhs, operator: .notIn, rhs: rhs)
}

//func <><T>(_ lhs: ColumnExpression<T>, _ rhs: ColumnExpression<T>) -> CompareExpression<ColumnExpression<T>> {
//    CompareExpression(lhs: lhs, operator: .notEqual, rhs: rhs)
//}
//
//func ><<T>(_ lhs: ColumnExpression<T>, _ rhs: ColumnExpression<T>) -> CompareExpression<ColumnExpression<T>> {
//    CompareExpression(lhs: lhs, operator: .notEqual, rhs: rhs)
//}
