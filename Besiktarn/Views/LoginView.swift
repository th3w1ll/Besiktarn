//
//  LoginView.swift
//  Besiktarn
//
//  Created by Patrik Korab on 2022-12-19.
//

import SwiftUI

struct LoginView: View {
    
    @State var loginEmail = ""
    @State var loginPassword = ""
    
    @StateObject var loginBase = LoginViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                
                Image("beslogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 300, height: 300)
                    .padding(.top)
                    
                    
                
                Spacer()

                if (loginBase.errorRegister) {
                    Text("Felaktig Registrering")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.red/*@END_MENU_TOKEN@*/)
                }
                
                if (loginBase.errorLogin) {
                    Text("Felaktig Inloggning")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.red/*@END_MENU_TOKEN@*/)
                }
                
                Text("Logga in")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                TextField("E-post", text: $loginEmail)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(.roundedBorder)
                
                SecureField("Lösenord", text: $loginPassword)
                    .keyboardType(.default)
                    .textFieldStyle(.roundedBorder)
                
                HStack{
                    Button(action: {
                        loginBase.registerUser(userEmail: loginEmail, userPassword: loginPassword)
                    }, label: {
                        Text("Registrera")
                    })
                    .buttonStyle(.borderedProminent)
                    .tint(.teal)
                    .foregroundColor(.black)
                    
                    .padding()
                    
                    Button(action: {
                        loginBase.loginUser(userEmail: loginEmail, userPassword: loginPassword)
                    }, label: {
                        Text("Logga In")
                    })
                    .buttonStyle(.borderedProminent)
                    .tint(.teal)
                    .foregroundColor(.black)
                    
                }
            }
            
        }

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
