//
//  File.swift
//  
//
//  Created by 박진서 on 12/10/23.
//

import FirebaseFirestoreInternal

public class EZFirestore: EZFirestoreType {
    
    static private let db = Firestore.firestore()
    
    @available(iOS 13.0.0, *)
    public static func save(model: Codable, path: String) async throws {
        let encodedJson = try JSONEncoder().encode(model)
        
        guard let json = try JSONSerialization.jsonObject(with: encodedJson) as? [String : Any] else {
            print("[SwiftyFirebase] failed")
            throw EZFirestoreError.encodingFailed
        }
        
        //Identifiable
        if let model = model as? (any Identifiable) {
            try await db.collection(path).document(model.id as! String).setData(json, merge: true)
        } else {
            try await db.collection(path).addDocument(data: json)
        }
    }
    
    @available(iOS 13.0.0, *)
    public static func fetch<T: Codable>(type: T.Type, path: String, id: String) async throws -> T {
        let snapshot = try await db.collection(path).document(id).getDocument()
        guard let data = snapshot.data() else {
            throw EZFirestoreError.snapshotToDictionaryFailed
        }
        let jsonData = try JSONSerialization.data(withJSONObject: data)

        let model = try JSONDecoder().decode(T.self, from: jsonData)
        
        return model
    }
    
    @available(iOS 13.0.0, *)
    public static func fetchList<T: Codable>(of: T.Type, path: String) async throws -> [T] {
        let snapshots = try await db.collection(path).getDocuments()
        var models: [T] = []
        
        for snapshot in snapshots.documents {
            let data = snapshot.data()
            
            let jsonData = try JSONSerialization.data(withJSONObject: data)

            let model = try JSONDecoder().decode(T.self, from: jsonData)
            models.append(model)
        }
        
        return models
    }
}
