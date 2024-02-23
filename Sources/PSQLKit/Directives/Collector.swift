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
    
    mutating func append(exp: some HavingSQLExpression) {
        guard !exp.havingIsNull else { return }
        expressions.append(exp.havingSqlExpression)
    }
    
    mutating func append(exp: some GroupBySQLExpression) {
        guard !exp.groupByIsNull else { return }
        expressions.append(exp.groupBySqlExpression)
    }
    
    mutating func append(exp: some WithSQLExpression) {
        guard !exp.withIsNull else { return }
        expressions.append(exp.withSqlExpression)
    }
    
    mutating func append(exp: some OrderBySQLExpression) {
        guard !exp.orderByIsNull else { return }
        expressions.append(exp.orderBySqlExpression)
    }
    
    mutating func append(exp: some UnionSQLExpression) {
        guard !exp.unionIsNull else { return }
        expressions.append(exp.unionSqlExpression)
    }
    
    mutating func append(exp: some QuerySQLExpression) {
        guard !exp.queryIsNull else { return }
        expressions.append(exp.querySqlExpression)
    }
}
