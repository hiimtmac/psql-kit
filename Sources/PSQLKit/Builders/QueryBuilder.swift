import Foundation

@_functionBuilder
struct QueryBuilder {
    typealias Expression = PSQLExpression
    typealias Component = PSQLExpression
    
    static func buildBlock(_ components: Component...) -> Component {
        PSQLList(components, separator: PSQLRaw.space)
    }
    
    static func buildExpression(_ expression: Expression) -> Component {
        expression
    }
}
