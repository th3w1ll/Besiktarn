//
//  MainViewModel.swift
//  Besiktarn
//
//  Created by Patrik Korab on 2022-12-19.
//

import Foundation
import Firebase
import FirebaseStorage

class MainViewModel : ObservableObject {
    
    var ref: DatabaseReference! = Database.database().reference()
    
    @Published var clients = [ClientViewModel]()
    @Published var isLoading = false
    
    
    func saveData (besName : String) {
        
        let userId = Auth.auth().currentUser!.uid
        
        var dataSave = [String : Any]()
        dataSave ["besName"] = besName
        
        if (besName == "") {
            return
        } else {
            ref.child(userId).child("Clients").childByAutoId().setValue(dataSave)
            { error, ref in
                
                if(error == nil) {
                    self.loadData()
                    
                } else {
                    
                }
            }
        }
    }
    
    func loadData() {
        
        clients = []
        
        let userId = Auth.auth().currentUser!.uid
        
        isLoading = true
        
        ref.child(userId).child("Clients").getData(completion: { error, snapshot in
            
            for listData in snapshot!.children {
                
                let listSnapshot = listData as! DataSnapshot
                
                let clientData = listSnapshot.value as! [String : Any]
                let besId = listSnapshot.key
                
                
                let client = ClientViewModel()
                client.besName = clientData["besName"] as! String
                client.besId = besId
                
                self.clients.append(client)
            }
            
            self.isLoading = false

        })
    }
    
    func deleteItem(offsets: IndexSet) {
        let delList = offsets.map { clients[$0] }
        if let clientToDelete = delList.first {
            print(clientToDelete.besName)
            
            let ref: DatabaseReference! = Database.database().reference()
            
            let userId = Auth.auth().currentUser!.uid
            
            
            
            ref.child(userId).child("Rooms").child(clientToDelete.besId).getData(completion: { error, snapshot in
                
                for listData in snapshot!.children {
                    
                    let listSnapshot = listData as! DataSnapshot
                    
                    let roomData = listSnapshot.value as! [String : Any]
                    let roomId = listSnapshot.key
                    
                    let room = RoomViewModel()
                    room.roomName = roomData["roomName"]as! String
                    room.roomId = roomId
                    
                    // Here we will put the code that will get us all assosiated noteIds:
                    
                    ref.child(userId).child("Notes").child(room.roomId).getData(completion: { error, snapshot in
                        
                        for listData in snapshot!.children {
                            
                            let listSnapshot = listData as! DataSnapshot
                            
                            let noteData = listSnapshot.value as! [String : Any]
                            let noteId = listSnapshot.key
                            
                            let note = NoteViewModel()
                            note.roomNote = noteData["roomNote"]as! String
                            note.noteId = noteId
                            
                            let storage = Storage.storage()
                            let storageRef = storage.reference()
                            
                            let delPic = storageRef.child("images").child(userId).child(note.noteId)
                            
                            delPic.delete { error in
                                if let error = error {
                                    print("Uh-oh, an error occurred!")
                                } else {
                                    print("File deleted successfully")
                                }
                            }
                            
                            
                        }
                    })
                    
                    
                    
                    //Here that code ends
                    
                    
                    
                    ref.child(userId).child("Notes").child(room.roomId).removeValue()
                }
            })
            ref.child(userId).child("Rooms").child(clientToDelete.besId).removeValue()
            
            ref.child(userId).child("Clients").child(clientToDelete.besId).removeValue()
            
            
        }
    }
    
    
}
