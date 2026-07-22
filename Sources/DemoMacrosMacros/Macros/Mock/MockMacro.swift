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

        let classDecl = try ClassDeclSyntax(
            "\(raw: protocolDecl.accessPrefix)final class Mock\(protocolDecl.name.trimmed): \(raw: protocolDecl.name.text)"
        ) {

        }

        return [
            DeclSyntax(classDecl)
        ]
    }
}
