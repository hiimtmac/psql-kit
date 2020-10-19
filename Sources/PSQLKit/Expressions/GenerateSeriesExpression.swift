import Foundation
import SQLKit
import PostgresKit

public struct GenerateSeriesExpression<Content>: SQLExpression where Content: SelectSQLExpressible & Comparable {
    let content: ClosedRange<Content>
    let interval: SQLExpression
    
    public init(_ content: ClosedRange<Content>, interval: SQLExpression) {
        self.content = content
        self.interval = interval
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("GENERATE_SERIES")
        serializer.write("(")
        content.lowerBound.selectSqlExpression.serialize(to: &serializer)
        serializer.write(",")
        serializer.writeSpace()
        content.upperBound.selectSqlExpression.serialize(to: &serializer)
        serializer.write(",")
        serializer.writeSpace()
        interval.serialize(to: &serializer)
        serializer.write("::INTERVAL")
        serializer.write(")")
    }
}

extension GenerateSeriesExpression: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { self }
}

extension GenerateSeriesExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<GenerateSeriesExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

extension GenerateSeriesExpression: FromSQLExpressible {
    public var fromSqlExpression: some SQLExpression { self }
}
