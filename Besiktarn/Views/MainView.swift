//
//  MainView.swift
//  Besiktarn
//
//  Created by Patrik Korab on 2022-12-19.
//

import SwiftUI
import Firebase

struct MainView: View {
    
    @State var clientName = ""
    
    @ObservedObject var currentClient : ClientViewModel
    
    @StateObject var mainViewModel = MainViewModel()
    
    @State var logBool = false
    @State var delBool = false
    @StateObject var settingsClass = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            
            VStack{
                List {
                    ForEach (mainViewModel.clients, id: \.besId) { client in
                        NavigationLink(destination: ClientView(clientClass: client)) {
                            Text(client.besName)
                        }
                    }
                    .onDelete(perform: mainViewModel.deleteItem)
                }
                .listStyle(.inset)
                
                Spacer()
                
                HStack {
                    TextField("Client Name", text: $clientName)
                        .keyboardType(.default)
                        .padding(.leading)
                        .textFieldStyle(.roundedBorder)
                    
                    
                    Button(action: {
                        mainViewModel.saveData(besName: clientName)
                        clientName = ""
                    }, label: {
                        Text("Lägg till")
                    })
                    .buttonStyle(.bordered)
                    .tint(.white)
                    .foregroundColor(.black)
                    .padding()
                    
                }
                
                .toolbar {
                    Menu{
                        Button(role:.none, action: {
                            logBool = true
                        }, label: {
                            Label("Logga Ut", systemImage: "rectangle.portrait.and.arrow.right")
                        })
                        
                        Button(role:.destructive, action: {
                            delBool = true
                        }, label: {
                            Label("Radera Konto", systemImage: "trash")
                        })
                        
                    }label: {
                        Label("Option",systemImage: "ellipsis.circle")
                            .tint(.black)
                    }
                }
                if (mainViewModel.isLoading)
                {
                    LoadingView()
                }
            }
            .navigationTitle("Klienter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(
                            Color.teal,
                            for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                        .background(Color.teal.ignoresSafeArea(edges: .bottom))
            
            

        }
        .frame(maxWidth: .infinity)
        .padding(.top)
        .background(Color.teal.ignoresSafeArea(edges: .top))
        .frame(maxWidth: .infinity)
        .tint(.black)
        
        .onAppear(){
            mainViewModel.loadData()
        }
        .alert("Du kommer att loggas ut", isPresented: $logBool, actions: {
            
            Button("Logga Ut", action: {
                settingsClass.logoutUser()
            })
            Button("Avbryt", role: .cancel, action: {})
        }, message: {
            Text("Logga in igen för att fortsätta")
        })
        
        .alert("Kontot kommer att raderas", isPresented: $delBool, actions: {
            
            Button("Ta Bort", action: {
                settingsClass.deletePictures()
                settingsClass.deleteUser()
            })
            Button("Avbryt", role: .cancel, action: {})
        }, message: {
            Text("Det går inte att ångra denna åtgärd")
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(currentClient: ClientViewModel())
    }
}
