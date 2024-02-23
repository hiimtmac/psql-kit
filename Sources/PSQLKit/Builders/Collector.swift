//
//  File.swift
//  
//
//  Created by Taylor McIntyre on 2024-02-22.
//

import Foundation
import protocol SQLKit.SQLExpression

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
    
    mutating func append(exp: some FromSQLExpression) {
        guard !exp.fromIsNull else { return }
        expressions.append(exp.fromSqlExpression)
    }
    
    mutating func append(exp: some JoinSQLExpression) {
        guard !exp.joinIsNull else { return }
        expressions.append(exp.joinSqlExpression)
    }
    
    mutating func append(exp: some WhereSQLExpression) {
        guard !exp.whereIsNull else { return }
        expressions.append(exp.whereSqlExpression)
    }
    
    mutating func append(exp: some UpdateSQLExpression) {
        guard !exp.updateIsNull else { return }
        expressions.append(exp.updateSqlExpression)
    }
    
    mutating func append(column: some InsertSQLExpression) {
        guard !column.insertIsNull else { return }
        expressions.append(column.insertColumnSqlExpression)
    }
    
    mutating func append(value: some InsertSQLExpression) {
        guard !value.insertIsNull else { return }
        expressions.append(value.insertValueSqlExpression)
    }
}
