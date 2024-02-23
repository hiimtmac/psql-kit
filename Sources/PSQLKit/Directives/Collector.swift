//
//  File.swift
//  
//
//  Created by Taylor McIntyre on 2024-02-22.
//

import Foundation
import SQLKit

struct Collector {
    var expressions: [any SQLExpression] = []
    
    mutating func append(exp: some SelectSQLExpression) {
        guard !exp.selectIsNull else { return }
        expressions.append(exp.selectSqlExpression)
    }
    
    mutating func append(exp: some FromSQLExpression) {
        guard !exp.fromIsNull else { return }
        expressions.append(exp.fromSqlExpression)
    }
}
