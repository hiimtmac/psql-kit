import Foundation
import SQLKit

struct GenerateSeriesExpression<Content>: SQLExpression where Content: SelectSQLExpressible & Comparable {
    let content: ClosedRange<Content>
    let interval: SQLExpression
    
    init(_ content: ClosedRange<Content>, interval: SQLExpression) {
        self.content = content
        self.interval = interval
    }
    
    func serialize(to serializer: inout SQLSerializer) {
        serializer.write("GENERATE_SERIES")
        serializer.write("(")
        content.lowerBound.selectSqlExpression.serialize(to: &serializer)
        serializer.write(",")
        serializer.writeSpace()
        content.upperBound.selectSqlExpression.serialize(to: &serializer)
        serializer.write(",")
        serializer.writeSpace()
        interval.serialize(to: &serializer)
        serializer.write("::interval")
        serializer.write(")")
    }
}

extension GenerateSeriesExpression: SelectSQLExpressible {
    var selectSqlExpression: Self { self }
}

extension GenerateSeriesExpression {
    func `as`(_ alias: String) -> ExpressionAlias<GenerateSeriesExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

extension GenerateSeriesExpression: FromSQLExpressible {
    var fromSqlExpression: Self { self }
}
