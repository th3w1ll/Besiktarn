//
//  SettingsViewModel.swift
//  Besiktarn
//
//  Created by Patrik Korab on 2022-12-19.
//

import Foundation
import Firebase
import FirebaseStorage

class SettingsViewModel : Identifiable ,ObservableObject {
    
    func deletePictures() {
        let userId = Auth.auth().currentUser!.uid

        let storage = Storage.storage()
        let storageRef = storage.reference()

        let folderRef = storageRef.child("images").child(userId)

        // List all the files in the folder
        folderRef.listAll { (result, error) in
          if let error = error {
            // Handle the error
              print("Uh-oh, an error occurred in list")
          } else {
            // Get a list of all the files in the folder
            let items = result!.items

            // Delete each file in the folder
            items.forEach { item in
              item.delete { error in
                if let error = error {
                  // Handle the error
                    print("Uh-oh, an error occurred in delete")
                } else {
                  // The file has been deleted
                }
              }
            }
          }
        }
    }
    
    func logoutUser() {
        
        try! Auth.auth().signOut()
        
    }
    
    func deleteUser() {
        var ref: DatabaseReference! = Database.database().reference()
        let user = Auth.auth().currentUser
        let userId = Auth.auth().currentUser!.uid
        
        ref.child(userId).removeValue()
        
        user?.delete { error in
            if let error = error {
                print("Error user.delete")
            } else {
                print("Account deleted")
            }
        }
    }
    
//    func logoutAlert(logBool : Bool) {
//        .alert("Du kommer att loggas ut", isPresented: logBool, actions: {
//
//            Button("Logga Ut", action: {
//                settingsClass.logoutUser()
//            })
//            Button("Avbryt", role: .cancel, action: {})
//        }, message: {
//            Text("Logga in igen för att fortsätta")
//        })
        
        
        
//    }
    
    
}
