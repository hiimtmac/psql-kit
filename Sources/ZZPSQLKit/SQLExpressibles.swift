import Foundation
import SQLKit

protocol SelectSQLExpressible {
    associatedtype Select: SQLExpression
    var selectSqlExpression: Select { get }
}

protocol FromSQLExpressible {
    associatedtype From: SQLExpression
    var fromSqlExpression: From { get }
}
