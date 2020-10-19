import Foundation
import SQLKit

struct PSQLBind<T>: CompareSQLExpressible, TypeEquatable where T: PSQLExpressible & Encodable {
    typealias CompareType = T
    
    let bind: SQLBind
    
    init(_ value: T) {
        self.bind = SQLBind(value)
    }
    
    var compareSqlExpression: SQLBind { bind }
}

