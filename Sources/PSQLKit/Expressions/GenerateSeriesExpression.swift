import Foundation

typealias GENERATE_SERIES = GenerateSeriesExpression

struct GenerateSeriesExpression<T: PSQLable>: PSQLExpression, FunctionExpression {
    let bottom: PSQLExpression
    let top: PSQLExpression
    let interval: PSQLExpression
    
    init<U: PSQLable>(from: T, to: T, interval: U) {
        self.bottom = from
        self.top = to
        self.interval = interval
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("GENERATE_SERIES")
        serializer.write("(")
        bottom.serialize(to: &serializer)
        serializer.write(",")
        serializer.writeSpace()
        top.serialize(to: &serializer)
        serializer.write(",")
        serializer.writeSpace()
        interval.serialize(to: &serializer)
        serializer.write("::interval")
        serializer.write(")")
    }
}

extension GenerateSeriesExpression: ExpressibleAsFrom {
    var from: PSQLExpression { self }
}
