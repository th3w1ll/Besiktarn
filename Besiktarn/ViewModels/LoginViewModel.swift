//
//  LoginViewModel.swift
//  Besiktarn
//
//  Created by Patrik Korab on 2022-12-19.
//

import Foundation
import Firebase

class LoginViewModel: ObservableObject {
    
    @Published var errorLogin = false
    
    @Published var errorRegister = false
    
    @Published var isLoading = false
    
    func loginUser(userEmail : String, userPassword : String) {
        isLoading = true
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { authResult, error in
            self.isLoading = false
            if(error != nil) {
                print("Misslyckad Inloggning")
                self.errorLogin = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.errorLogin = false
                }
                
            }
        }
    }
    
    func registerUser(userEmail : String, userPassword : String) {
        isLoading = true
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { authResult, error in
            self.isLoading = false
            print(error)
            
            if(error != nil) {
                print("Misslyckad Registrering")
                self.errorRegister = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.errorRegister = false
                }
            }
        }
    }
}
