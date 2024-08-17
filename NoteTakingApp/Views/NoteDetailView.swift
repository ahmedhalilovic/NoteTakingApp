//
//  NoteDetailView.swift
//  NoteTakingApp
//
//  Created by Ahmed Halilovic on 16. 8. 2024..
//

import SwiftUI

struct NoteDetailView: View {
    // Accesses the shared ImageData object from the environment, allowing for shared state accros multiple views
    @EnvironmentObject var imageData: ImageData
    // Declares a local state variable of type ImageNote, specific to this view, to manage its own instance of the data
    @State var note: ImageNote
    // Accesses the current view's presentation mode, allowing control over whether the view is presented or dismissed
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    Image(uiImage: UIImage(data: note.image)!)
                        .resizable()
                        .frame(width: 300, height: 300, alignment: .center)
                    Spacer()
                }
                TextField("Edit me", text: $note.title) // With binding to the note.title, we are able to display the value and also update it when the user types something new
                    .textSelection(.enabled) // Allows us to be able to select text within textfield
                    .onTapGesture {
                        // Clears the text in the TextField when tapped
                        note.title = ""
                    }
                ZStack {
                    TextEditor(text: $note.description)
                        .textSelection(.enabled)
                        .frame(height: 200)
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("\(note.description.count)/120")
                                .foregroundColor(.gray)
                                //.font(.system(size: 15))
                        }
                    }
                }
                HStack {
                    Spacer()
                    Button("Confirm changes") {
                        imageData.editNote(id: note.id, title: note.title, description: note.description)
                        presentationMode.wrappedValue.dismiss()
                    }
                    Spacer()
                }
            }
        }
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let tempImage = UIImage(systemName: "map")?.pngData()
        
        NoteDetailView(note: ImageNote(id: UUID(), image: tempImage!, title: "Test", description: "Test Description"))
            .environmentObject(ImageData())
    }
}
