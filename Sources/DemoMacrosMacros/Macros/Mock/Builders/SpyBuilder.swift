//
//  SpyBuilder.swift
//  talk-demo
//
//  Created by Mahmood Tahir on 2026-07-10.
//

import SwiftSyntax

struct SpyBuilder: MemberBlockBuilder {
    func build(from decl: ProtocolDeclSyntax) throws -> MemberBlockItemListSyntax {
        let publicPrefix = decl.accessPrefix
        return try MemberBlockItemListSyntax {
            try StructDeclSyntax("\(raw: publicPrefix)struct Spy: Sendable") {
                for function in decl.functions {
                    let parameters = function.parameters.map { $0.type.trimmed.description }.joined(separator: ", ")
                    """
                    fileprivate let \(function.name.trimmed)Tracker = MacroTypes._FunctionCallTracker<(\(raw: parameters))>()
                            
                    \(raw: publicPrefix)var \(function.name.trimmed)Calls: [(\(raw: parameters))] {
                        \(function.name.trimmed)Tracker.calls
                    }
                    """
                }
            }

            """
            \(raw: publicPrefix)let spy = Spy()
            """
        }
    }
}
