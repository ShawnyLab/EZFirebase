//
//  File.swift
//  
//
//  Created by 박진서 on 12/13/23.
//

import FirebaseStorage
import UIKit

@available(iOS 15.0.0, *)
open class EZStorage {
    static private let ref = Storage.storage().reference()
    
    static func save(data: Data, path: String) async throws -> URL {
        
        let storageRef = ref.child(path)
        
        let _ = try await storageRef.putDataAsync(data)
        return try await storageRef.downloadURL()
    }
    
    static func save(data: Data, path: String, completion: @escaping (URL) -> ()) {
        
        let storageRef = ref.child(path)
        
        storageRef.putData(data) { metaData, error in
            if let error {
                print("EZFirebase failed : \(error)")
                return
            }
            
            guard let metaData else {
                print("EZFirebase failed : No MetaData")
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error {
                    print("EZFirebase failed : \(error)")
                    return
                }
                
                if let url {
                    
                    completion(url)
                } else {
                    print("EZFirebase failed : URL Download Failed")
                    return
                }
            }
        }
    }
    
    static func saveImage(image: UIImage, path: String, _ quality: CGFloat = 1.0) async throws -> URL {

        let storageRef = ref.child(path)
        
        guard let data = image.jpegData(compressionQuality: quality) else {
            throw EZStorageError.imageToDataFailed
        }
        
        let _ = try await storageRef.putDataAsync(data)
        return try await storageRef.downloadURL()
    }
}
