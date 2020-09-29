import Foundation

protocol ExpressibleAsColumn {
    var columnExpression: PSQLColumnExpression { get }
}

protocol ExpressibleAsColumnSelection {
    var selectionExpression: PSQLColumnSelectionExpression { get }
}

extension PSQLSelectExpression where Self: ExpressibleAsColumnSelection {
    var psqlSelectExpression: PSQLExpression { selectionExpression }
}

struct Column<T: PSQLable>: ExpressibleAsColumn, ExpressibleAsColumnSelection, PSQLSelectExpression {
    let aliasName: String?
    let pathName: String?
    let schemaName: String?
    let columnName: String
    
    public init(aliasName: String? = nil, pathName: String? = nil, schemaName: String? = nil, columnName: String) {
        self.aliasName = aliasName
        self.pathName = pathName
        self.schemaName = schemaName
        self.columnName = columnName
    }
    
    var selectionExpression: PSQLColumnSelectionExpression {
        PSQLColumnColumnSelection(
            aliasName: aliasName,
            pathName: pathName,
            schemaName: schemaName,
            columnName: columnName,
            columnType: T.psqlType.psqlValue,
            columnAlias: nil
        )
    }
    
    var columnExpression: PSQLColumnExpression {
        PSQLColumnExpression(
            aliasName: aliasName,
            pathName: pathName,
            schemaName: schemaName,
            columnName: columnName
        )
    }
}

struct LiteralColumn<T: PSQLExpression & PSQLable>: ExpressibleAsColumnSelection {
    let value: T
    
    public init(_ value: T) {
        self.value = value
    }
    
    var selectionExpression: PSQLColumnSelectionExpression {
        PSQLLiteralColumnSelection(
            value: value,
            type: T.psqlType.psqlValue,
            columnAlias: nil
        )
    }
}

struct RawColumn<T: PSQLable>: ExpressibleAsColumn, ExpressibleAsColumnSelection, PSQLSelectExpression {
    let columnName: String
    
    public init(_ column: String) {
        self.columnName = column
    }
    
    var selectionExpression: PSQLColumnSelectionExpression {
        PSQLColumnColumnSelection(
            aliasName: nil,
            pathName: nil,
            schemaName: nil,
            columnName: columnName,
            columnType: T.psqlType.psqlValue,
            columnAlias: nil
        )
    }
    
    var columnExpression: PSQLColumnExpression {
        PSQLColumnExpression(
            aliasName: nil,
            pathName: nil,
            schemaName: nil,
            columnName: columnName
        )
    }
}

extension Column where T == Date {
    var simple: Column<SimpleDate> {
        .init(
            aliasName: aliasName,
            pathName: pathName,
            schemaName: schemaName,
            columnName: columnName
        )
    }
    
    var timestamp: Column<TimestampDate> {
        .init(
            aliasName: aliasName,
            pathName: pathName,
            schemaName: schemaName,
            columnName: columnName
        )
    }
}

extension Column: TypeComparable {}
