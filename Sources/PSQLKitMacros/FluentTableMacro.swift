// FluentTableMacro.swift
// Copyright (c) 2024 hiimtmac inc.

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum FluentTableMacro {
    enum TableMacroError: Error, CustomStringConvertible {
        case nonClass

        var description: String {
            switch self {
            case .nonClass: "@FluentCTE can only be applied to `class`s"
            }
        }
    }
}

extension FluentTableMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let publicKeyword = TokenSyntax.keyword(.public)
        let publicMod = DeclModifierSyntax(name: .keyword(.public))
        let staticMod = DeclModifierSyntax(name: .keyword(.static))

        guard
            let identified = declaration.asProtocol(NamedDeclSyntax.self),
            let classDecl = identified.as(ClassDeclSyntax.self)
        else {
            throw TableMacroError.nonClass
        }

        guard
            let attribute = classDecl.attributes.first?.as(AttributeSyntax.self),
            let argumentList = attribute.arguments?.as(LabeledExprListSyntax.self),
            let tableArgument = argumentList.first,
            let tableExpression = tableArgument.expression.as(StringLiteralExprSyntax.self),
            let tableSegment = tableExpression.segments.first?.as(StringSegmentSyntax.self)
        else {
            return []
        }

        let schemaInitializer = if
            argumentList.count > 1,
            let schemaArgument = argumentList.last,
            let schemaExpression = schemaArgument.expression.as(StringLiteralExprSyntax.self),
            let schemaSegment = schemaExpression.segments.first?.as(StringSegmentSyntax.self)
        {
            InitializerClauseSyntax(
                equal: .equalToken(),
                value: StringLiteralExprSyntax(
                    openingQuote: .stringQuoteToken(),
                    segments: StringLiteralSegmentListSyntax(
                        arrayLiteral: StringLiteralSegmentListSyntax.Element(
                            StringSegmentSyntax(
                                content: .stringSegment(schemaSegment.content.text)
                            )
                        )
                    ),
                    closingQuote: .stringQuoteToken()
                )
            )
        } else {
            InitializerClauseSyntax(
                equal: .equalToken(),
                value: NilLiteralExprSyntax(nilKeyword: .keyword(.nil))
            )
        }

        let isPublic = classDecl.modifiers.contains(where: { $0.name.text == publicKeyword.text })

        let tableName = MemberBlockItemListSyntax.Element(
            decl: VariableDeclSyntax(
                modifiers: isPublic
                    ? DeclModifierListSyntax(arrayLiteral: publicMod, staticMod)
                    : DeclModifierListSyntax(arrayLiteral: staticMod),
                bindingSpecifier: .keyword(.let),
                bindings: PatternBindingListSyntax(
                    arrayLiteral: PatternBindingSyntax(
                        pattern: IdentifierPatternSyntax(
                            identifier: .identifier("schema")
                        ),
                        typeAnnotation: TypeAnnotationSyntax(
                            colon: .colonToken(),
                            type: IdentifierTypeSyntax(
                                name: .identifier("String")
                            )
                        ),
                        initializer: InitializerClauseSyntax(
                            equal: .equalToken(),
                            value: StringLiteralExprSyntax(
                                openingQuote: .stringQuoteToken(),
                                segments: StringLiteralSegmentListSyntax(
                                    arrayLiteral: StringLiteralSegmentListSyntax.Element(
                                        StringSegmentSyntax(
                                            content: .stringSegment(tableSegment.content.text)
                                        )
                                    )
                                ),
                                closingQuote: .stringQuoteToken()
                            )
                        )
                    )
                )
            )
        )

        let schemaName = MemberBlockItemListSyntax.Element(
            decl: VariableDeclSyntax(
                modifiers: isPublic
                    ? DeclModifierListSyntax(arrayLiteral: publicMod, staticMod)
                    : DeclModifierListSyntax(arrayLiteral: staticMod),
                bindingSpecifier: .keyword(.let),
                bindings: PatternBindingListSyntax(
                    arrayLiteral: PatternBindingSyntax(
                        pattern: IdentifierPatternSyntax(
                            identifier: .identifier("space")
                        ),
                        typeAnnotation: TypeAnnotationSyntax(
                            colon: .colonToken(),
                            type: OptionalTypeSyntax(
                                wrappedType: IdentifierTypeSyntax(
                                    name: .identifier("String")
                                ),
                                questionMark: .postfixQuestionMarkToken()
                            )
                        ),
                        initializer: schemaInitializer
                    )
                )
            )
        )

        let queryContainer = MemberBlockItemListSyntax.Element(
            decl: VariableDeclSyntax(
                modifiers: isPublic
                ? DeclModifierListSyntax(arrayLiteral: publicMod, staticMod)
                : DeclModifierListSyntax(arrayLiteral: staticMod),
                bindingSpecifier: .keyword(.let),
                bindings: PatternBindingListSyntax(
                    arrayLiteral: PatternBindingSyntax(
                        pattern: IdentifierPatternSyntax(
                            identifier: .identifier("queryContainer")
                        ),
                        initializer: InitializerClauseSyntax(
                            equal: .equalToken(),
                            value: FunctionCallExprSyntax(
                                calledExpression: DeclReferenceExprSyntax(
                                    baseName: .identifier("QueryContainer")
                                ),
                                leftParen: .leftParenToken(),
                                arguments: LabeledExprListSyntax(),
                                rightParen: .rightParenToken(),
                                additionalTrailingClosures: MultipleTrailingClosureElementListSyntax()
                            )
                        )
                    )
                )
            )
        )

        let tableRecord = ExtensionDeclSyntax(
            extensionKeyword: .keyword(.extension),
            extendedType: IdentifierTypeSyntax(name: .identifier(classDecl.name.text)),
            inheritanceClause: InheritanceClauseSyntax(
                colon: .colonToken(),
                inheritedTypes: InheritedTypeListSyntax(
                    arrayLiteral: InheritedTypeListSyntax.Element(
                        type: IdentifierTypeSyntax(
                            name: .identifier("Table")
                        )
                    )
                )
            ),
            memberBlock: MemberBlockSyntax(
                leftBrace: .leftBraceToken(),
                members: MemberBlockItemListSyntax(
                    arrayLiteral: tableName, schemaName, queryContainer
                ),
                rightBrace: .rightBraceToken()
            )
        )

        return [tableRecord]
    }
}

 extension FluentTableMacro: MemberMacro {
    struct ColumnInfo {
        let variableName: String
        let columnName: String
        let type: String
        let isPublic: Bool
    }

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let publicKeyword = TokenSyntax.keyword(.public)
        let publicMod = DeclModifierSyntax(name: .keyword(.public))

        guard
            let identified = declaration.asProtocol(NamedDeclSyntax.self),
            let classDecl = identified.as(ClassDeclSyntax.self)
        else {
            throw TableMacroError.nonClass
        }

        let isPublic = classDecl.modifiers.contains(where: { $0.name.text == publicKeyword.text })

        let columnList = declaration
            .memberBlock
            .members
            .compactMap { member -> ColumnInfo? in
                guard
                    let variable = member.decl.as(VariableDeclSyntax.self),
                    let binding = variable.bindings.first,
                    // is a non-computed property
                    binding.accessorBlock == nil,
                    let identifier = binding.pattern.as(IdentifierPatternSyntax.self),
                    let typeAnnotation = binding.typeAnnotation?.type
                else {
                    return nil
                }

                guard
                    let attribute = variable.attributes.first?.as(AttributeSyntax.self),
                    let attributeName = attribute.attributeName.as(IdentifierTypeSyntax.self)
                else {
                    return nil
                }

                let columnName: String
                let isID = attributeName.name.text == "ID"
                let isField = attributeName.name.text == "Field"
                let isOptionalField = attributeName.name.text == "OptionalField"
                let isGroup = attributeName.name.text == "Group"
                let isParent = attributeName.name.text == "Parent"
                let isOptionalParent = attributeName.name.text == "OptionalParent"
                let isTimestamp = attributeName.name.text == "Timestamp"

                if isID {
                    columnName = identifier.identifier.text
                } else if
                    isField || isOptionalField || isGroup || isParent || isOptionalParent || isTimestamp,
                    let argumentList = attribute.arguments?.as(LabeledExprListSyntax.self),
                    let argument = argumentList.first,
                    let expression = argument.expression.as(StringLiteralExprSyntax.self),
                    let segment = expression.segments.first?.as(StringSegmentSyntax.self)
                {
                    columnName = segment.content.text
                } else {
                    return nil
                }

                var type: String
                if let simple = typeAnnotation.as(IdentifierTypeSyntax.self) {
                    type = simple.name.text
                } else if let member = typeAnnotation.as(MemberTypeSyntax.self), let base = member.baseType.as(IdentifierTypeSyntax.self) {
                    type = "\(base.name.text).\(member.name.text)"
                } else if let optional = typeAnnotation.as(OptionalTypeSyntax.self)?.wrappedType {
                    if let simple = optional.as(IdentifierTypeSyntax.self) {
                        type = simple.name.text
                    } else if let member = optional.as(MemberTypeSyntax.self), let base = member.baseType.as(IdentifierTypeSyntax.self) {
                        type = "\(base.name.text).\(member.name.text)"
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
                
                if isParent || isOptionalParent {
                    type += ".IDValue"
                }

                let isPublic = variable.modifiers.contains(where: { $0.name.text == publicKeyword.text })

                return .init(
                    variableName: identifier.identifier.text,
                    columnName: columnName,
                    type: type,
                    isPublic: isPublic
                )
            }

        let columnAccessors = columnList.map { columnInfo -> MemberBlockItemSyntax in
            MemberBlockItemSyntax(
                decl: VariableDeclSyntax(
                    attributes: AttributeListSyntax(
                        arrayLiteral: AttributeListSyntax.Element(
                            AttributeSyntax(
                                atSign: .atSignToken(),
                                attributeName: IdentifierTypeSyntax(
                                    name: .identifier("ColumnAccessor"),
                                    genericArgumentClause: GenericArgumentClauseSyntax(
                                        leftAngle: .leftAngleToken(),
                                        arguments: GenericArgumentListSyntax(
                                            arrayLiteral: GenericArgumentSyntax(
                                                argument: IdentifierTypeSyntax(
                                                    name: .identifier(columnInfo.type)
                                                )
                                            )
                                        ),
                                        rightAngle: .rightAngleToken()
                                    )
                                ),
                                leftParen: .leftParenToken(),
                                arguments: AttributeSyntax.Arguments(
                                    LabeledExprListSyntax(
                                        arrayLiteral: LabeledExprSyntax(
                                            expression: StringLiteralExprSyntax(
                                                openingQuote: .stringQuoteToken(),
                                                segments: StringLiteralSegmentListSyntax(
                                                    arrayLiteral: StringLiteralSegmentListSyntax.Element(
                                                        StringSegmentSyntax(
                                                            content: .stringSegment(columnInfo.columnName)
                                                        )
                                                    )
                                                ),
                                                closingQuote: .stringQuoteToken()
                                            )
                                        )
                                    )
                                ),
                                rightParen: .rightParenToken()
                            )
                        )
                    ),
                    modifiers: columnInfo.isPublic
                    ? DeclModifierListSyntax(arrayLiteral: publicMod)
                    : DeclModifierListSyntax(),
                    bindingSpecifier: .keyword(.var),
                    bindings: PatternBindingListSyntax(
                        arrayLiteral: PatternBindingSyntax(
                            pattern: IdentifierPatternSyntax(
                                identifier: .identifier(columnInfo.variableName)
                            ),
                            typeAnnotation: TypeAnnotationSyntax(
                                colon: .colonToken(),
                                type: IdentifierTypeSyntax(
                                    name: .identifier("Never")
                                )
                            )
                        )
                    )
                )
            )
        }

        let query = DeclSyntax(
            StructDeclSyntax(
                attributes: AttributeListSyntax(),
                modifiers: isPublic
                ? DeclModifierListSyntax(arrayLiteral: publicMod)
                : DeclModifierListSyntax(),
                structKeyword: .keyword(.struct),
                name: .identifier("QueryContainer"),
                memberBlock: MemberBlockSyntax(
                    leftBrace: .leftBraceToken(),
                    members: MemberBlockItemListSyntax(columnAccessors),
                    rightBrace: .rightBraceToken()
                )
            )
        )

        return [query]
    }
 }
