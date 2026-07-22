//
//  ConformanceBuilder.swift
//  talk-demo
//
//  Created by Mahmood Tahir on 2026-07-10.
//

import SwiftSyntax

struct ConformanceBuilder: MemberBlockBuilder {
    func build(from decl: ProtocolDeclSyntax) throws -> MemberBlockItemListSyntax {
        try MemberBlockItemListSyntax {
            for function in decl.functions {
                try FunctionDeclSyntax("\(raw: function.description)") {
                    "spy.\(raw: function.name)Tracker.called((\(raw: function.parameters.map { $0.secondName?.text ?? $0.firstName.text }.joined(separator: ", "))))"

                    if function.isThrowing {
                        """
                        guard let result = stubs.\(raw: function.name)Result else {
                            throw StubError.\(raw: function.name)
                        }
                        """
                        """
                        switch result {
                        case .success(let value):
                            return value
                        case .failure(let error):
                            throw error
                        }
                        """
                    } else {
                        """
                        guard let result = stubs.\(raw: function.name)Result else {
                            fatalError("Does not throw but expected failure")
                        }
                        """

                        """
                        switch result {
                        case .success(let value):
                            return value
                        case .failure:
                            fatalError("Does not throw but expected failure")
                        }
                        """
                    }
                }
            }
        }
    }
}
