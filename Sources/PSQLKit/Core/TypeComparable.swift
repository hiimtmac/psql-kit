import Foundation

protocol TypeComparable: ExpressibleAsSelect {
    associatedtype T: PSQLable
}
