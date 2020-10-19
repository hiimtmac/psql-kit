import Foundation
import SQLKit
import PostgresKit

protocol PSQLDate: Comparable, PSQLExpressible, Decodable, Encodable {
    var storage: Foundation.Date { get }
    static var defaultFormatter: DateFormatter { get }
}

extension PSQLDate {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.storage < rhs.storage
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        Self.defaultFormatter.string(from: storage).serialize(to: &serializer)
        serializer.write("::")
        Self.postgresColumnType.serialize(to: &serializer)
    }
}

extension Foundation.Date {
    public var psqlDate: Date { .init(self) }
    public var psqlTime: Time { .init(self) }
    public var psqlTimestamp: Timestamp { .init(self) }
    public var psqlTimestampZ: TimestampZ { .init(self) }
}

public struct Date: PSQLDate {
    let storage: Foundation.Date
    
    init(_ date: Foundation.Date = .init()) {
        self.storage = date
    }
    
    static let defaultFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
}

extension Date: PSQLExpressible {
    public typealias CompareType = Self
    public static var postgresColumnType: PostgresColumnType { .date }
}

extension Date: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { self }
}

public struct Time: PSQLDate {
    let storage: Foundation.Date
    
    public init(_ date: Foundation.Date = .init()) {
        self.storage = date
    }
    
    static let defaultFormatter: DateFormatter = {
        fatalError("Not implemented")
    }()
}

extension Time: PSQLExpressible {
    public typealias CompareType = Self
    public static var postgresColumnType: PostgresColumnType { .time }
}

extension Time: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { self }
}

public struct Timestamp: PSQLDate {
    let storage: Foundation.Date
    
    public init(_ date: Foundation.Date = .init()) {
        self.storage = date
    }
    
    static let defaultFormatter: DateFormatter = {
        fatalError("Not implemented")
    }()
}

extension Timestamp: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { self }
}

extension Timestamp: PSQLExpressible {
    public typealias CompareType = Self
    public static var postgresColumnType: PostgresColumnType { .timestamp }
}

public struct TimestampZ: PSQLDate {
    let storage: Foundation.Date
    
    public init(_ date: Foundation.Date = .init()) {
        self.storage = date
    }
    
    static let defaultFormatter: DateFormatter = {
        fatalError("Not implemented")
    }()
}

extension TimestampZ: PSQLExpressible {
    public typealias CompareType = Self
    public static var postgresColumnType: PostgresColumnType { .timestamptz }
}

extension TimestampZ: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { self }
}
