//
//  AuthenticationService.swift
//  SignUpForm2
//
//  Created by Jungjin Park on 2024-06-20.
//

import Foundation
import Combine

struct AuthenticationService {
    func checkUserNameAvailablePublisher(userName: String) -> AnyPublisher<Bool, Error> {
        return Fail(error: APIError.invalidResponse).eraseToAnyPublisher()
    }
}
