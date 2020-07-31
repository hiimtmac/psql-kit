import Foundation

protocol PSQLable: PSQLExpression {
    static var psqlType: PSQLType { get }
}
