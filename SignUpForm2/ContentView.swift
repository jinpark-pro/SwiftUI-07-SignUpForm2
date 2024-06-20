//
//  ContentView.swift
//  SignUpForm2
//
//  Created by Jungjin Park on 2024-06-20.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SignUpFormViewModel()
    var body: some View {
        Form {
            Section {
                TextField("Username", text: $viewModel.username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            } footer: {
                Text(viewModel.usernameMessage)
                    .foregroundStyle(Color.red)
            }
            Section {
                Button("Sign Up") {
                    print("Signing up as \(viewModel.username)")
                }
                .disabled(!viewModel.isValid)
                
            }
        }
        .alert("Please update", isPresented: $viewModel.showUpdateDialog, actions: {
            Button("Upgrade") {
            
            }
            Button("Not now", role: .cancel) {}
        }, message: {
            Text("It looks like your're using an older version of this app. Please update your app.")
        })
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
