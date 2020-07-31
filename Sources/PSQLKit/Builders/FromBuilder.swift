import Foundation

@_functionBuilder
struct FromBuilder {
    typealias Expression = PSQLFromExpression
    typealias Component = PSQLExpression
    
    static func buildBlock(_ components: Component...) -> Component {
        PSQLList(components)
    }
    
    static func buildExpression(_ expression: Expression) -> Component {
        expression
    }
    
    static func buildExpression<T: ExpressibleAsFrom>(_ select: T) -> Component {
        select.from
    }
}
