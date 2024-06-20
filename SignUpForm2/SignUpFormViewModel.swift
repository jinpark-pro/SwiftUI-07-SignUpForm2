//
//  SignUpFormViewModel.swift
//  SignUpForm2
//
//  Created by Jungjin Park on 2024-06-20.
//

import Foundation

class SignUpFormViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var usernameMessage: String = ""
    @Published var isValid: Bool = false
    @Published var showUpdateDialog: Bool = false
}
