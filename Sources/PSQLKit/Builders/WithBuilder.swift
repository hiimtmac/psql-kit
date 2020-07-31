import Foundation

@_functionBuilder
struct WithBuilder {
    typealias Expression = PSQLExpression
    typealias Component = PSQLExpression
    
    static func buildBlock(_ components: Component...) -> Component {
        PSQLList(components)
    }
    
    static func buildExpression(_ expression: Expression) -> Component {
        expression
    }
}
