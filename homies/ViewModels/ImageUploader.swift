//
//  ImageUploader.swift
//  homies
//
//  Created by Phakphum Artkaew on 5/1/23.
//

import Foundation
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import SwiftUI

class ImageUploader: ObservableObject {
  let storage = Storage.storage()
  let user = Auth.auth().currentUser
  let db = Database.database()

    func uploadImage(image: UIImage, uploadPath: String) {
    let storageRef = storage.reference().child(uploadPath)
//    let storageRef = storage.reference().child(user!.uid).child("images").child("profilepicture")
    let imageData = image.jpegData(compressionQuality: 0.5)
//    let dbRef = db.reference()

    // Upload the file and send as message to db
    if let imageData = imageData {
      storageRef.putData(imageData, metadata: nil).observe(.success) { snapshot in
        // Upload completed successfully
//        dbRef.child("messages").childByAutoId().setValue(["imageUrl": storageRef.fullPath, "displayName": Auth.auth().currentUser!.displayName])
      }
    }
  }
}

