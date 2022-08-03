//
//  Firebase.swift
//  Wazoooom!
//
//  Created by Phumin Abdul Hameed on 02/04/21.
//

import UIKit
import Firebase
import FirebaseFirestore

class Firebase: NSObject {
    
    static let db = Firestore.firestore()
    static let storage = Storage.storage()

    class func uploadPhoto(data: Data,userId: String, completion:@escaping(Bool,Error?) -> Void, currentProgress:@escaping (CGFloat) -> Void) {
        let storageRef = storage.reference()
        let uuid = UUID().uuidString
        let imageRef = storageRef.child(String(format: "%@/%@.jpeg", userId, uuid))
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let uploadTask = imageRef.putData(data, metadata: metadata) { (metadata, error) in
            if let _ = error {
                completion(false, error)
            }
            else {
                
            }
        }
        
        uploadTask.observe(.success) { (snapshot) in
            if snapshot.status == .success {
                updateuserPhotos(userId: userId, photoId: uuid) { (success) in
                    completion(true, nil)
                }

            }
        }
        uploadTask.observe(.progress) { (snapshot) in
            
            let progress = CGFloat(snapshot.progress!.completedUnitCount) /  CGFloat(snapshot.progress!.totalUnitCount)
            if progress >= 1 {
                //updateuserPhotos(userId: userId, photoId: uuid)

            }
            currentProgress(progress)
        }
        
        
    }
    
    class func updateuserPhotos(userId: String, photoId: String, completion:@escaping(Bool) -> Void) {
        db.collection("Users").whereField("userId", isEqualTo: userId).getDocuments { (snapshot, error) in
            if let _ = error {
                //completion(false, error)
            }
            else {
                let user = snapshot?.documents[0].data()
                var images: [String] = []
                if let image = user!["images"] as? [String] {
                    images = image
                }
                images.append(String(format: "%@/%@.jpeg", userId, photoId))
                snapshot?.documents.first?.reference.updateData(["images":images], completion: { (error) in
                    if let _ = error {
                        completion(false)
                    }
                    else {
                        completion(true)

                    }
                })
                
            }
        }
    }
    
    class func getImages(userId: String, completion:@escaping([String],Bool,Error?) -> Void) {
        db.collection("Users").whereField("userId", isEqualTo: userId).getDocuments { (snapshot, error) in
            if let _ = error {
                //completion(false, error)
            }
            else {
                let user = snapshot?.documents[0].data()
                var images: [String] = []
                if let image = user!["images"] as? [String] {
                    images = image
                }
                completion(images,true,nil)
                
            }
        }

    }
    
    class func storeUser(user:[String:String], completion:@escaping(Bool,Error?) -> Void) {
        db.collection("Users").whereField("userName", isEqualTo: user["userName"]!)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(false, error)
                }
                else {
                    if (snapshot?.documents.count)! > 0 {
                        completion(false,nil)
                    }
                    else {
                        db.collection("Users").addDocument(data: user)
                        completion(true,nil)
                    }
                }
            }
    
    }
    
    class func checkUserNameAndPassword(user:[String:Any], completion:@escaping([String:Any],Bool,Error?) -> Void) {
        db.collection("Users").whereField("userName", isEqualTo: user["userName"] as! String).whereField("password", isEqualTo: user["password"] as! String).getDocuments { (snapshot, error) in
            if let _ = error {
                completion([:],false,error)
            }
            else {
                if snapshot?.documents.count == 0 {
                    completion(["text":"Invalid login credentials"], false, nil)
                }
                else {
                    completion((snapshot?.documents[0].data())!, true, nil)
                }
            }
        }
        
    }
    
}
