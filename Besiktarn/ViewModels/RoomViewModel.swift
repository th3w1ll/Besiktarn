//
//  RoomViewModel.swift
//  Besiktarn
//
//  Created by Patrik Korab on 2022-12-19.
//

import Foundation
import Firebase
import FirebaseStorage

class RoomViewModel : Identifiable ,ObservableObject {
    
    var ref: DatabaseReference! = Database.database().reference()
    
    @Published var noteList = [NoteViewModel]()
    
    @Published var roomId = ""
    @Published var roomName = ""
    
    func savedata (roomNote : String) {
        
        let userId = Auth.auth().currentUser!.uid
        
        var dataSave = [String : Any]()
        dataSave ["roomNote"] = roomNote
        
        if (roomNote == "") {
            return
        } else {
            ref.child(userId).child("Notes").child(roomId).childByAutoId().setValue(dataSave)
            { error, ref in
                
                if(error == nil) {
                    self.loadData()
                    
                } else {
                    
                }
            }
        }
    }
    
    func loadData() {
        
        noteList = []
        
        let userId = Auth.auth().currentUser!.uid
        
        ref.child(userId).child("Notes").child(roomId).getData(completion: { error, snapshot in
            
            for listData in snapshot!.children {
                
                let listSnapshot = listData as! DataSnapshot
                
                let noteData = listSnapshot.value as! [String : Any]
                let noteId = listSnapshot.key
                
                let note = NoteViewModel()
                note.roomNote = noteData["roomNote"]as! String
                note.noteId = noteId
                
                self.noteList.append(note)
            }
        })
    }
    
    func deleteItem(offsets: IndexSet) {
        let delList = offsets.map { noteList[$0] }
        if let clientToDelete = delList.first {
            print(clientToDelete.noteId)
            
            let ref: DatabaseReference! = Database.database().reference()
            
            let userId = Auth.auth().currentUser!.uid
            
            let storage = Storage.storage()
            let storageRef = storage.reference()
            
            let delPic = storageRef.child("images").child(userId).child(clientToDelete.noteId)
            
            delPic.delete { error in
                if let error = error {
                    print("Uh-oh, an error occurred!")
                } else {
                    print("File deleted successfully")
                }
            }
            
            ref.child(userId).child("Notes").child(roomId).child(clientToDelete.noteId).removeValue()
            
        }
    }
    
    
}

