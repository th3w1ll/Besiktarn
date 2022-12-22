//
//  Room.swift
//  Besiktarn
//
//  Created by Patrik Korab on 2022-12-19.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseStorage

struct RoomView: View {
    
    var ref: DatabaseReference! = Database.database().reference()
    
    @State var roomText = ""
    @State var rumName = ""
    
    @StateObject var roomClass = RoomViewModel()
    
    @State var logBool = false
    @State var delBool = false
    @StateObject var settingsClass = SettingsViewModel()
    
    var body: some View {
        
        ZStack{
            Color.white
            
            VStack{
                List {
                    ForEach (roomClass.noteList, id: \.noteId) { note in
                        NavigationLink(destination: PictureView(noteClass: note)) {
                            Text(note.roomNote)
                        }
                    }
                    .onDelete(perform: roomClass.deleteItem)
                }
                .listStyle(.inset)
                
                Spacer()
                
                HStack{
                    TextField("Anteckning", text: $roomText)
                        .keyboardType(.default)
                        .padding(.leading)
                        .textFieldStyle(.roundedBorder)
                    
                    Button(action: {
                        roomClass.savedata(roomNote: roomText)
                        roomText = ""
                    }, label: {
                        Text("Lägg till")
                    })
                    .buttonStyle(.borderedProminent)
                    .tint(.teal)
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
                .navigationTitle(rumName)
                .toolbarBackground(
                                Color.teal,
                                for: .navigationBar)
                            .toolbarBackground(.visible, for: .navigationBar)
    //                        .background(Color.teal.ignoresSafeArea(edges: .bottom))
                
                .onAppear(){
                    roomClass.loadData()
                    rumName = roomClass.roomName
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
        

    }
    
}




struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        RoomView()
    }
}
