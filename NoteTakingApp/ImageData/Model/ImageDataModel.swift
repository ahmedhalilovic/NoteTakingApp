//
//  ImageDataModel.swift
//  NoteTakingApp
//
//  Created by Ahmed Halilovic on 16. 8. 2024..
//

import Foundation
import SwiftUI

struct ImageNote: Codable, Hashable, Identifiable {
    var id = UUID()
    var image: Data
    var title: String
    var description: String
}

@MainActor class ImageData: ObservableObject {
    private let IMAGES_KEY = "ImagesKey"
    var imageNote: [ImageNote] {
        didSet {
            objectWillChange.send()
            saveData()
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: IMAGES_KEY) {
            if let decodedNotes = try? JSONDecoder().decode([ImageNote].self, from: data) {
                imageNote = decodedNotes
                print("Note data sucessfully retreived")
                return
            }
        }
        imageNote = []
    }
    
    // Func that turn image to .png so it can be added as data
    func addNote(image: UIImage, title: String, desc: String) {
        if let pngRepresentation = image.pngData() {
            let tempNote = ImageNote(image: pngRepresentation, title: title, description: desc)
            imageNote.insert(tempNote, at: 0)
            print("Note added")
            saveData()
        }
    }
    
    // Func to edit existing note
    func editNote(id: UUID, title: String, description: String) {
        if let note = imageNote.first(where: {$0.id == id}) {
            let index = imageNote.firstIndex(of: note)
            
            imageNote[index!].title = title // Index must not be null
            imageNote[index!].description = description // Index must not be null
        }
    }
    
    // This func should be private because it only neds to be seen in this class
    private func saveData() {
        if let encodedNotes = try? JSONEncoder().encode(imageNote) {
            UserDefaults.standard.set(encodedNotes, forKey: IMAGES_KEY)
        }
    }
    
    // Func to reset all data
    func resetUserData() {
        UserDefaults.standard.removeObject(forKey: IMAGES_KEY)
        UserDefaults.resetStandardUserDefaults()
        
        imageNote = []
    }
}
