//
//  Publisher+Dump.swift
//  SignUpForm2
//
//  Created by Jungjin Park on 2024-06-20.
//

import Foundation
import Combine

extension Publisher {
    func dump() -> AnyPublisher<Self.Output, Self.Failure> {
        handleEvents(receiveOutput: { value in
            Swift.print(">>")
            Swift.dump(value)
        }, receiveCompletion: { value in
            Swift.print("<<")
            Swift.dump(value)
        })
        .eraseToAnyPublisher()
    }
}
