//
//  NoteViewModel.swift
//  Besiktarn
//
//  Created by Patrik Korab on 2022-12-19.
//

import Foundation

class NoteViewModel : Identifiable ,ObservableObject {
    
    @Published var noteId = ""
    @Published var roomNote = ""
}
