//
//  ClientView.swift
//  Besiktarn
//
//  Created by Patrik Korab on 2022-12-19.
//

import SwiftUI
import Firebase

struct ClientView: View {
    
    @State var rumName = ""
    @State var clientName = ""
    
    @StateObject var clientClass = ClientViewModel()
    
    @State var logBool = false
    @State var delBool = false
    @StateObject var settingsClass = SettingsViewModel()
    
    var body: some View {
        
        VStack{
            List {
                ForEach (clientClass.roomList, id: \.roomId) { room in
                    NavigationLink(destination: RoomView(roomClass: room)) {
                        Text(room.roomName)
                    }
                }
                .onDelete(perform: clientClass.deleteItem)
            }
            .listStyle(.inset)
            
            Spacer()
            
            HStack {
                TextField("Room Name", text: $rumName)
                    .keyboardType(.default)
                    .padding(.leading)
                    .textFieldStyle(.roundedBorder)
                
                
                Button(action: {
                    clientClass.saveData(roomName: rumName)
                    rumName = ""
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
            .navigationTitle(clientName)
            .toolbarBackground(
                            Color.teal,
                            for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                        .background(Color.teal.ignoresSafeArea(edges: .bottom))
        }
        .onAppear(){
            clientClass.loadData()
            clientName = clientClass.besName
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

struct BesiktningView_Previews: PreviewProvider {
    static var previews: some View {
        ClientView()
    }
}
