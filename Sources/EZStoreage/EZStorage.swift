//
//  File.swift
//  
//
//  Created by 박진서 on 12/10/23.
//

import FirebaseStorage
import Foundation

public class EZFirestore {
    static private let ref = Storage.storage().reference()

    public func save(path: String, name: String?, data: Data) async throws -> URL {
        var storageRef = ref.child(path)
        
        if let name {
            storageRef = ref.child(path).child(name)
        }
        
        let _ = try await storageRef.putDataAsync(data)
        
        return try await storageRef.downloadURL()
    }
}
