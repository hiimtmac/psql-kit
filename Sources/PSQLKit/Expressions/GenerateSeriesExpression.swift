import Foundation
import SQLKit
import PostgresKit

public struct GenerateSeriesExpression<Content>: SQLExpression where Content: SelectSQLExpression {
    let lower: Content
    let upper: Content
    let interval: SQLExpression
    
    public init(from lower: Content, to upper: Content, interval: SQLExpression) {
        self.lower = lower
        self.upper = upper
        self.interval = interval
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("GENERATE_SERIES")
        serializer.write("(")
        lower.selectSqlExpression.serialize(to: &serializer)
        serializer.write(",")
        serializer.writeSpace()
        upper.selectSqlExpression.serialize(to: &serializer)
        serializer.write(",")
        serializer.writeSpace()
        interval.serialize(to: &serializer)
        serializer.write("::INTERVAL")
        serializer.write(")")
    }
}

extension GenerateSeriesExpression: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression { self }
}

extension GenerateSeriesExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<GenerateSeriesExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

extension GenerateSeriesExpression: FromSQLExpression {
    public var fromSqlExpression: some SQLExpression { self }
}
