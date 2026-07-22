//
//  Utils.swift
//  talk-demo
//
//  Created by Mahmood Tahir on 2026-07-10.
//

import SwiftSyntax

enum MacroError: Error {
    case invalidVariableRequirement
}

extension FunctionDeclSyntax {
    var isStatic: Bool {
        modifiers.contains {
            $0.name.tokenKind == .keyword(.static)
        }
    }

    var returnType: TypeSyntax? {
        signature.returnClause?.type
    }

    var isVoid: Bool {
        signature.returnClause == nil
    }

    var parameters: FunctionParameterListSyntax {
        signature.parameterClause.parameters
    }

    var isThrowing: Bool {
        #if swift(>=6.0) && canImport(SwiftSyntax600)
        signature.effectSpecifiers?.throwsClause?.throwsSpecifier.tokenKind == .keyword(.throws)
        #else
        signature.effectSpecifiers?.throwsSpecifier?.tokenKind == .keyword(.throws)
        #endif
    }
}

extension DeclModifierListSyntax {
    var isPublic: Bool {
        contains { $0.name.tokenKind == .keyword(.public) }
    }

    var isOpen: Bool {
        contains { $0.name.tokenKind == .keyword(.open) }
    }

    /// The prefix for properties based on scope
    var accessPrefix: String {
        isPublic || isOpen ? "public " : ""
    }
}

extension ProtocolDeclSyntax {
    var isPublic: Bool {
        modifiers.isPublic
    }

    var isOpen: Bool {
        modifiers.isOpen
    }

    /// The prefix for properties based on scope
    var accessPrefix: String {
        modifiers.accessPrefix
    }

    var functions: [FunctionDeclSyntax] {
        memberBlock.members
            .compactMap { $0.decl.as(FunctionDeclSyntax.self) }
            .filter {
                !$0.isStatic
            }
    }
}

extension VariableDeclSyntax {
    var isStatic: Bool {
        modifiers.contains(where: { $0.name.tokenKind == .keyword(.static) })
    }

    var isComputed: Bool {
      guard
        self.bindings.count == 1,
        let binding = self.bindings.first
      else { return false }

      return self.bindingSpecifier.tokenKind == .keyword(.var) && binding.isComputed
    }
}

extension PatternBindingSyntax {
  var isComputed: Bool {
    guard let accessors = self.accessorBlock?.accessors else { return false }

    switch accessors {
    case .accessors(let accessors):
      let tokenKinds = accessors.compactMap { $0.accessorSpecifier.tokenKind }
      let propertyObservers: [TokenKind] = [.keyword(.didSet), .keyword(.willSet)]

      return !tokenKinds.allSatisfy(propertyObservers.contains)

    case .getter(_):
      return true
    }
  }
}
