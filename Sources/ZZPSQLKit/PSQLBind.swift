import Foundation
import SQLKit

struct PSQLBind<T> where T: PSQLExpressible & Encodable {
    let bind: SQLBind
    
    init(_ value: T) {
        self.bind = SQLBind(value)
    }
}

extension PSQLBind: CompareSQLExpressible {
    var compareSqlExpression: SQLBind { bind }
}

extension PSQLBind: TypeEquatable {
    typealias CompareType = T
}
