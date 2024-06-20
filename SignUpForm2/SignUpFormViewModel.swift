//
//  SignUpFormViewModel.swift
//  SignUpForm2
//
//  Created by Jungjin Park on 2024-06-20.
//

import Foundation
import Combine

class SignUpFormViewModel: ObservableObject {
    typealias Available = Result<Bool, Error>
    
    @Published var username: String = ""
    @Published var usernameMessage: String = ""
    @Published var isValid: Bool = false
    @Published var showUpdateDialog: Bool = false
    
    private var authenticationService = AuthenticationService()
    
    private lazy var isUsernameAvailablePublisher: AnyPublisher<Available, Never> = {
        $username
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            // 또다른 publisher 를 사용하기위해 .flatMap 사용
            .flatMap { username -> AnyPublisher<Available, Never> in
                self.authenticationService.checkUserNameAvailablePublisher(userName: username)
                    .asResult()
            }
            .receive(on: DispatchQueue.main)
            .print("before share")
            // 결과 공유를 위해 share 사용
            // 서버에서 자료는 한번 가져오고 가져온 결과를 공유
            .share()
            .print("share")
            .dump()
            .eraseToAnyPublisher()
    }()
    
    init() {
        isUsernameAvailablePublisher.map { result in
            switch result {
            case .success(let isAvailable):
                return isAvailable
            case .failure(let error):
                if case APIError.transportError(_) = error {
                    return true
                }
                return false
            }
        }
        .assign(to: &$isValid)
        
        isUsernameAvailablePublisher.map { result in
            switch result {
            case .success(let isAvailable):
                return isAvailable ? "" : "This username is not available."
            case .failure(let error):
                if case APIError.transportError(_) = error {
                    return ""
                } else if case APIError.validationError(let reason) = error {
                    return reason
                } else if case APIError.serverError(statusCode: _, reason: let reason, retryAfter: _) = error {
                    return reason ?? "Server error"
                }
                            
                return error.localizedDescription
            }
        }
        .assign(to: &$usernameMessage)
        
        isUsernameAvailablePublisher.map { result in
            if case .failure(let error) = result {
                if case APIError.decodingError = error {
                    return true
                }
            }
            return false
        }
        .assign(to: &$showUpdateDialog)
    }
}
