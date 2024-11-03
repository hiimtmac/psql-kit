// _ConditionalContent.swift
// Copyright (c) 2024 hiimtmac inc.

public enum _ConditionalContent<T: Sendable, U: Sendable>: Sendable {
    case left(T)
    case right(U)
}
