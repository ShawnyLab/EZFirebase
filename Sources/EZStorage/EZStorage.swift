//
//  File.swift
//  
//
//  Created by 박진서 on 12/13/23.
//

//import FirebaseStorageCombineSwift
//import FirebaseStorage
//
//open class EZStorage {
//    static private let ref = Storage.storage().reference()
//    
//    static func save(data: Data, path: String) async throws -> URL {
//        
//        let storageRef = ref.child(path)
//        
//        let _ = try await storageRef.putDataAsync(data)
//        return try await storageRef.downloadURL()
//    }
//}
