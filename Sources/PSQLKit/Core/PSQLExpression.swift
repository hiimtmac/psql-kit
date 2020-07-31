import Foundation

protocol PSQLExpression {
    func serialize(to serializer: inout PSQLSerializer)
}
