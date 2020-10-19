import Foundation
import SQLKit
import PostgresKit

protocol PSQLDate: Comparable, PSQLExpressible {
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
    var psqlDate: Date { .init(self) }
    var psqlTime: Time { .init(self) }
    var psqlTimestamp: Timestamp { .init(self) }
    var psqlTimestampZ: TimestampZ { .init(self) }
}

struct Date: PSQLDate {
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
    typealias CompareType = Self
    static var postgresColumnType: PostgresColumnType { .date }
}

extension Date: SelectSQLExpressible {
    var selectSqlExpression: Self { self }
}

struct Time: PSQLDate {
    let storage: Foundation.Date
    
    init(_ date: Foundation.Date = .init()) {
        self.storage = date
    }
    
    static let defaultFormatter: DateFormatter = {
        fatalError("Not implemented")
    }()
}

extension Time: PSQLExpressible {
    typealias CompareType = Self
    static var postgresColumnType: PostgresColumnType { .time }
}

extension Time: SelectSQLExpressible {
    var selectSqlExpression: Self { self }
}

struct Timestamp: PSQLDate {
    let storage: Foundation.Date
    
    init(_ date: Foundation.Date = .init()) {
        self.storage = date
    }
    
    static let defaultFormatter: DateFormatter = {
        fatalError("Not implemented")
    }()
}

extension Timestamp: SelectSQLExpressible {
    var selectSqlExpression: Self { self }
}

extension Timestamp: PSQLExpressible {
    typealias CompareType = Self
    static var postgresColumnType: PostgresColumnType { .timestamp }
}

struct TimestampZ: PSQLDate {
    let storage: Foundation.Date
    
    init(_ date: Foundation.Date = .init()) {
        self.storage = date
    }
    
    static let defaultFormatter: DateFormatter = {
        fatalError("Not implemented")
    }()
}

extension TimestampZ: PSQLExpressible {
    typealias CompareType = Self
    static var postgresColumnType: PostgresColumnType { .timestamptz }
}

extension TimestampZ: SelectSQLExpressible {
    var selectSqlExpression: Self { self }
}
