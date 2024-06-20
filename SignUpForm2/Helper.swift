//
//  Helper.swift
//  SignUpForm2
//
//  Created by Jungjin Park on 2024-06-20.
//

import Foundation
import Combine

struct UserNameAvailableMessage: Codable {
    var isAvailable: Bool
    var userName: String
}

struct APIErrorMessage: Decodable {
    var error: Bool
    var reason: String
}

enum APIError: LocalizedError {
    case invalidResponse
}

extension Publisher {
    func asResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        self.map(Result.success)
            .catch { error in
                Just(.failure(error))
            }
            .eraseToAnyPublisher()
    }
}
