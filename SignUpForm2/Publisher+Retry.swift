//
//  Publisher+Retry.swift
//  SignUpForm2
//
//  Created by Jungjin Park on 2024-06-20.
//

import Foundation
import Combine

extension Publisher {
    func retry<T, E> (_ retryCount: Int, withBackOff initialBackOff: Int, condition: ((E) -> Bool)? = nil) -> Publishers.TryCatch<Self, AnyPublisher<T, E>> where T == Self.Output, E == Self.Failure {
        return self.tryCatch { error -> AnyPublisher<T, E> in
            if condition?(error) == true {
                var backOff = initialBackOff
                return Just(Void())
                    .flatMap { _ -> AnyPublisher<T, E> in
                        let result = Just(Void())
                            .delay(for: .init(integerLiteral: backOff), scheduler: DispatchQueue.global())
                            .flatMap { _ in return self }
                        backOff = backOff * 2
                        return result.eraseToAnyPublisher()
                    }
                    .retry(retryCount - 1)
                    .eraseToAnyPublisher()
                
            } else {
                throw error
            }
        }
    }
}
