//
//  ClientViewModel.swift
//  Besiktarn
//
//  Created by Patrik Korab on 2022-12-19.
//

import Foundation
import Firebase
import FirebaseStorage

class ClientViewModel : ObservableObject, Identifiable {
    
    var ref: DatabaseReference! = Database.database().reference()
    
    @Published var roomList = [RoomViewModel]()
    
    @Published var besId = ""
    @Published var besName = ""
    
    
    func saveData (roomName : String) {
        
        let userId = Auth.auth().currentUser!.uid
        
        var dataSave = [String : Any]()
        dataSave ["roomName"] = roomName
        
        if (roomName == "") {
            return
        } else {
            ref.child(userId).child("Rooms").child(besId).childByAutoId().setValue(dataSave)
            { error, ref in
                
                if(error == nil) {
                    self.loadData()
                    
                } else {
                    
                }
            }
        }
    }
    
    func loadData() {
        
        roomList = []
        
        let userId = Auth.auth().currentUser!.uid
        
        ref.child(userId).child("Rooms").child(besId).getData(completion: { error, snapshot in
            
            for listData in snapshot!.children {
                
                let listSnapshot = listData as! DataSnapshot
                
                let roomData = listSnapshot.value as! [String : Any]
                let roomId = listSnapshot.key
                
                let room = RoomViewModel()
                room.roomName = roomData["roomName"]as! String
                room.roomId = roomId
                
                self.roomList.append(room)
                
                
            }
        })
    }
    
    func deleteItem(offsets: IndexSet) {
        let delList = offsets.map { roomList[$0] }
        if let clientToDelete = delList.first {
            print(clientToDelete.roomId)
            
            let ref: DatabaseReference! = Database.database().reference()
            
            let userId = Auth.auth().currentUser!.uid
            
            //We use this piece of code to find the current noteIDs that are connected to the current room that will be deleted so we also delete the pictures assosiated with the notes
            ref.child(userId).child("Notes").child(clientToDelete.roomId).getData(completion: { error, snapshot in
                
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
            
            ref.child(userId).child("Clients").getData(completion: { error, snapshot in
                
                for listData in snapshot!.children {
                    
                    let listSnapshot = listData as! DataSnapshot
                    
                    let clientData = listSnapshot.value as! [String : Any]
                    let besId = listSnapshot.key
                    
                    
                    let client = ClientViewModel()
                    client.besName = clientData["besName"] as! String
                    client.besId = besId
                    
                    ref.child(userId).child("Rooms").child(client.besId).child(clientToDelete.roomId).removeValue()
                    
                    
                }
            })
            ref.child(userId).child("Notes").child(clientToDelete.roomId).removeValue()
            
            
            
        }
    }
    
    
}

