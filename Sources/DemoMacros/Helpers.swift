//
//  Helpers.swift
//  talk-demo
//
//  Created by Mahmood Tahir on 2026-07-10.
//

@_exported import struct os.OSAllocatedUnfairLock
@_exported import struct Foundation.UUID

/// Namespaced types commonly used in mocks
public enum MacroTypes {
    /// Tracks function calls with parameters
    public final class _FunctionCallTracker<Parameters>: @unchecked Sendable {
        private let lock = OSAllocatedUnfairLock()
        private var _calls: [Parameters] = []
        public var calls: [Parameters] {
            lock.lock()
            defer { lock.unlock() }

            return self._calls
        }

        public func called(_ parameters: Parameters) {
            lock.lock()
            defer { lock.unlock() }

            _calls.append(parameters)
        }

        public init() {}
    }
}
