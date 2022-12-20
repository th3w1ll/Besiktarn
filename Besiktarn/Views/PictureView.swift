//
//  PictureView.swift
//  Besiktarn
//
//  Created by Patrik Korab on 2022-12-19.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseStorage

struct PictureView: View {
    
    var ref: DatabaseReference! = Database.database().reference()
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    //    @State private var displayImage: UIImage?
    @State private var isImagePickerDisplay = false
    
    @State var rumNote = ""
    
    @StateObject var noteClass = NoteViewModel()
    
    @State var logBool = false
    @State var delBool = false
    @StateObject var settingsClass = SettingsViewModel()
    
    var body: some View {
        VStack {
            
           
            
            if selectedImage != nil {
                
                Image(uiImage: selectedImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
            } else {
                Image(systemName: "photo.on.rectangle.angled")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            }
            
           
            Spacer()
            Color.white
            
            HStack{
                Spacer()
                Button(action: {
                    self.sourceType = .camera
                    self.isImagePickerDisplay.toggle()
                }, label: {
                    Text("Kamera")
                    Image(systemName: "camera.fill")
                        .buttonStyle(BorderlessButtonStyle())
                })
                .buttonStyle(.bordered)
                .tint(.white)
                .foregroundColor(.black)
                .padding(12)
                .padding(.leading)
                
//                Button(action: {
////                    self.sourceType = .camera
////                    self.isImagePickerDisplay.toggle()
//                }) {Text("Kamera")
//                    Image(systemName: "camera.fill")}
//                .onTapGesture {
//                    self.sourceType = .camera
//                    self.isImagePickerDisplay.toggle()
//                }
//                .buttonStyle(.borderedProminent)
//                .tint(.teal)
//                .padding(.leading)
                
                
                Spacer()
                
                Button(action: {
                    self.sourceType = .photoLibrary
                    self.isImagePickerDisplay.toggle()
                }, label: {
                    Text("Bibliotek")
                    Image(systemName: "photo.fill")
                        .buttonStyle(BorderlessButtonStyle())
                })
                .buttonStyle(.bordered)
                .tint(.white)
                .foregroundColor(.black)
                .padding(12)
                .padding(.trailing)
                Spacer()
            }
            
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
        .navigationTitle(rumNote)
        .toolbarBackground(
                        Color.teal,
                        for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .background(Color.teal.ignoresSafeArea(edges: .bottom))
        
        .sheet(isPresented: self.$isImagePickerDisplay) {
            ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
        }
        .onChange(of: selectedImage) { newValue in
            print("Bild Vald!")
            upploadImage()
        }
        .onAppear(){
            print("Bild Nedladdad")
            downloadImage()
            rumNote = noteClass.roomNote
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
    
    func upploadImage() {
        
        print(selectedImage!.size)
        
        let userId = Auth.auth().currentUser!.uid
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let savePlace = storageRef.child("images").child(userId).child(noteClass.noteId)
        
        let imageData = selectedImage!.jpegData(compressionQuality: 0.1)
        
        savePlace.putData(imageData!, metadata: nil) { (metadata, error) in
            
            if(error != nil) {
                print("Fel vid uppladning")
                
            } else {
                print("Ok vid uppladdning")
            }
        }
    }
    
    func downloadImage() {
        
        let userId = Auth.auth().currentUser!.uid
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let savePlace = storageRef.child("images").child(userId).child(noteClass.noteId)
        
        savePlace.getData(maxSize: 10*1024*1024) { data, error in
            
            if(error != nil) {
                print("Fel vid nedladdning")
                
            } else {
                print("Ok vid nedladdning")
                
                let noteImage = UIImage(data: data!)
                selectedImage = noteImage
            }
        }
    }
    
    func deleteImage() {
        
        let userId = Auth.auth().currentUser!.uid
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let delPic = storageRef.child("images").child(userId).child(noteClass.noteId)
        
        delPic.delete { error in
            if let error = error {
                print("Uh-oh, an error occurred!")
            } else {
                print("File deleted successfully")
            }
        }
        
    }
}





struct PictureView_Previews: PreviewProvider {
    static var previews: some View {
        PictureView()
    }
}



//All of this will be placed in a seperate file:
struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType
        imagePicker.delegate = context.coordinator // confirming the delegate
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}



class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePickerView
    
    init(picker: ImagePickerView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.picker.selectedImage = selectedImage
        self.picker.isPresented.wrappedValue.dismiss()
    }
}
