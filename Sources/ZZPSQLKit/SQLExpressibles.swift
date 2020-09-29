import Foundation
import SQLKit

protocol SelectSQLExpressible {
    associatedtype Select: SQLExpression
    var selectSqlExpression: Select { get }
}
