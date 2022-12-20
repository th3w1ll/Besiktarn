//
//  ContentView.swift
//  Besiktarn
//
//  Created by Patrik Korab on 2022-12-19.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @State var isLoggedIn = false
    
    
    var body: some View {
        
        VStack {
            
            if (isLoggedIn == false)
            {
                LoginView()
            } else {
                MainView(currentClient: ClientViewModel())
            }
        }.onAppear() {
            let handle = Auth.auth().addStateDidChangeListener { auth, user in
                
                if (Auth.auth().currentUser ==  nil) {
                    isLoggedIn = false
                } else {
                    isLoggedIn = true
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
