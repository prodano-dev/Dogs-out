//
//  Cancellable.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 25/11/2021.
//

import Combine

final class Cancellable {
    fileprivate(set) var subscriptions = Set<AnyCancellable>()

    public func cancel() {
        subscriptions.removeAll()
    }

    public func collect(@Builder _ cancelables: () -> [AnyCancellable]) {
        subscriptions.formUnion(cancelables())
    }

    @resultBuilder
    struct Builder {
        static func buildBlock(_ components: AnyCancellable...) -> [AnyCancellable] {
            return components
        }
    }
}

extension AnyCancellable {

    func store(in cancel: Cancellable) {
        cancel.subscriptions.insert(self)
    }
}
