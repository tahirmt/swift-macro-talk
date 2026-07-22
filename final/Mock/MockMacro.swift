import SwiftSyntax
import SwiftSyntaxMacros

public struct MockMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let protocolDecl = declaration.as(ProtocolDeclSyntax.self) else {
            throw MacroExpansionErrorMessage("@Mock can only be applied to protocols")
        }
        let mockName = "Mock\(protocolDecl.name.text)"

        let classDecl = try ClassDeclSyntax("\(raw: protocolDecl.accessPrefix)final class \(raw: mockName): \(raw: protocolDecl.name.text)") {
            try StubErrorBuilder().build(from: protocolDecl)
            try InitBuilder().build(from: protocolDecl)
            try StubBuilder().build(from: protocolDecl)
            try SpyBuilder().build(from: protocolDecl)
            try ConformanceBuilder().build(from: protocolDecl)
        }

        let codeblock = CodeBlockItemListSyntax {
            CodeBlockItemSyntax(item: .decl(DeclSyntax(classDecl)))
        }
        let ifClause = IfConfigClauseListSyntax {
            IfConfigClauseSyntax(
                poundKeyword: .poundIfToken(),
                condition: DeclReferenceExprSyntax(baseName: "DEBUG"),
                elements: .statements(codeblock)
            )
        }
        return [DeclSyntax(IfConfigDeclSyntax(clauses: ifClause))]
    }
}
