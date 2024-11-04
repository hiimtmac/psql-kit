//
//  File.swift
//  psql-kit
//
//  Created by Taylor McIntyre on 2024-11-04.
//

import PSQLKit
import FluentKit

extension JsonbExtractPathTextExpression {
    public init<T>(
        _ group: ColumnExpression<T>,
        _ keyPath: KeyPath<T, FieldProperty<T, Content>>
    ) {
        self.init(
            group,
            T()[keyPath: keyPath].key.description,
            as: Content.self
        )
    }

    public init<T>(
        _ group: ColumnExpression<T>,
        _ keyPath: KeyPath<T, OptionalFieldProperty<T, Content>>
    ) {
        self.init(
            group,
            T()[keyPath: keyPath].key.description,
            as: Content.self
        )
    }

    public init<T>(
        _ group: ColumnExpression<T>,
        _ keyPath: KeyPath<T, TimestampProperty<T, Content>>
    ) {
        self.init(
            group,
            T()[keyPath: keyPath].$timestamp.key.description,
            as: Content.self
        )
    }

    public init<T>(
        _ group: ColumnExpression<T>,
        _ keyPath: KeyPath<T, IDProperty<T, Content>>
    ) {
        self.init(
            group,
            T()[keyPath: keyPath].key.description,
            as: Content.self
        )
    }

    public init<T, U>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T, GroupProperty<T, U>>,
        _ second: KeyPath<U, FieldProperty<U, Content>>
    ) {
        self.init(
            group,
            T()[keyPath: first].key.description,
            U()[keyPath: second].key.description,
            as: Content.self
        )
    }

    public init<T, U>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T, GroupProperty<T, U>>,
        _ second: KeyPath<U, OptionalFieldProperty<U, Content>>
    ) {
        self.init(
            group,
            T()[keyPath: first].key.description,
            U()[keyPath: second].key.description,
            as: Content.self
        )
    }

    public init<T, U>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T, GroupProperty<T, U>>,
        _ second: KeyPath<U, TimestampProperty<U, Content>>
    ) {
        self.init(
            group,
            T()[keyPath: first].key.description,
            U()[keyPath: second].$timestamp.key.description,
            as: Content.self
        )
    }

    public init<T, U>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T, GroupProperty<T, U>>,
        _ second: KeyPath<U, IDProperty<U, Content>>
    ) {
        self.init(
            group,
            T()[keyPath: first].key.description,
            U()[keyPath: second].key.description,
            as: Content.self
        )
    }
}
