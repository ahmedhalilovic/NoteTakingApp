//
//  ImagePicker.swift
//  NoteTakingApp
//
//  Created by Ahmed Halilovic on 15. 8. 2024..
//

import UIKit
import SwiftUI

// This struct is a wrapper that allows using UIKit's UIImagePickerController in SwiftUI
struct ImagePicker: UIViewControllerRepresentable {
    
    // This property manages the presentation state (shown or dismissed) of the view
    @Environment(\.presentationMode)
    private var presentationMode
    
    // The source type (camera or photo library) from which the image will be picked
    let sourceType: UIImagePickerController.SourceType
    
    // A closure that gets called when an image is picked, passing the UIImage
    let onImagePicked: (UIImage) -> Void
    
    // The Coordinator class acts as a bridge between the UIKit and SwiftUI components
    final class Coordinator: NSObject,
                             UINavigationControllerDelegate,
                             UIImagePickerControllerDelegate {
        
        // Binding to manage the presentation mode of the view
        @Binding
        private var presentationMode: PresentationMode
        
        // The source type for the image picker (camera or photo library)
        private let sourceType: UIImagePickerController.SourceType
        
        // The closure to execute when an image is picked
        private let onImagePicked: (UIImage) -> Void
        
        // Initializer for the Coordinator, injecting necessary properties
        init(presentationMode: Binding<PresentationMode>,
             sourceType: UIImagePickerController.SourceType,
             onImagePicked: @escaping (UIImage) -> Void) {
            _presentationMode = presentationMode
            self.sourceType = sourceType
            self.onImagePicked = onImagePicked
        }
        
        // Called when the user finishes picking an image
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Extract the original image from the picker info dictionary
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            
            // Call the closure with the selected image
            onImagePicked(uiImage)
            
            // Dismiss the image picker
            presentationMode.dismiss()
        }
        
        // Called when the user cancels the image picking process
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // Dismiss the image picker
            presentationMode.dismiss()
        }
        
    }
    
    // This method creates the Coordinator, linking it with the ImagePicker
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode,
                           sourceType: sourceType,
                           onImagePicked: onImagePicked)
    }
    
    // This method creates the UIImagePickerController and sets its delegate to the Coordinator
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    // This method updates the UIImagePickerController, though no updates are required here
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {
        // No update required as the picker does not change once presented
    }
    
}
