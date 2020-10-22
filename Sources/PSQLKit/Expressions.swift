import Foundation
import SQLKit

public typealias COALESCE = CoalesceExpression
public typealias GENERATE_SERIES = GenerateSeriesExpression
public typealias MAX = MaxExpression
public typealias MIN = MinExpression
public typealias SUM = SumExpression
public typealias COUNT = CountExpression
public typealias AVG = AverageExpression
public typealias JSON_EXTRACT_PATH_TEXT = JsonExtractPathTextExpression
public typealias JSONB_EXTRACT_PATH_TEXT = JsonbExtractPathTextExpression

public typealias CONCAT = ConcatExpression
public typealias CONCAT3 = ConcatExpression3
public typealias CONCAT4 = ConcatExpression4
public typealias CONCAT5 = ConcatExpression5

public protocol Expression {
    
}

public protocol AggregateExpression: Expression {
    
}
