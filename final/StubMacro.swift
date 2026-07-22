import SwiftSyntax
import SwiftSyntaxMacros

protocol Stubbable: DeclSyntaxProtocol {
    var modifiers: DeclModifierListSyntax { get }
    var memberBlock: MemberBlockSyntax { get }
    var name: TokenSyntax { get }
}

extension StructDeclSyntax: Stubbable {}
extension ClassDeclSyntax: Stubbable {}

public struct StubMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let decl = try ExtensionDeclSyntax("extension \(type)") {
            // create the stub function

            if let structDecl = declaration.as(StructDeclSyntax.self) {
                return try StubsBuilder().build(from: structDecl)
            } else if let classDecl = declaration.as(ClassDeclSyntax.self) {
                return try StubsBuilder().build(from: classDecl)
            } else {
                throw MacroExpansionErrorMessage("@Stub cannot be applied to \(type).")
            }
        }

        return [decl]
    }
}

struct StubsBuilder<DeclSyntax: Stubbable>: MemberBlockBuilder {
    func build(from decl: DeclSyntax) throws -> MemberBlockItemListSyntax {
        let accessPrefix = decl.modifiers.accessPrefix

        let variables = decl.memberBlock.members
            .compactMap { $0.decl.as(VariableDeclSyntax.self) }
            .filter { !$0.isStatic && !$0.isComputed }

        return try MemberBlockItemListSyntax {
            if variables.isEmpty {
                try VariableDeclSyntax("\(raw: accessPrefix)static var stub: \(decl.name.trimmed)") {
                    """
                    \(decl.name.trimmed)()
                    """
                }
            } else {
                let functionArgumentsWithDefaultValue = try variables.map {
                    try "\($0.name): \($0.type) = \($0.defaultValue)"
                }
                let functionParameters = try variables.map {
                    try "\($0.name): \($0.name)"
                }

                try VariableDeclSyntax("\(raw: accessPrefix)static var stub: \(decl.name.trimmed)") {
                    """
                    stub()
                    """
                }

                try FunctionDeclSyntax(
                    "\(raw: accessPrefix)static func stub(\n\(raw: functionArgumentsWithDefaultValue.joined(separator: ",\n"))\n) -> \(decl.name.trimmed)"
                ) {
                    """
                    \(decl.name.trimmed)(
                    \(raw: functionParameters.joined(separator: ",\n"))
                    )
                    """
                }
            }
        }
    }
}
