import Foundation

protocol Directive: PSQLExpression {
    var psql: PSQLExpression { get }
//    var psqlSerialize: PSQL { get }
}
