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
    static func save(model: Codable, path: String, completion: @escaping () -> ()) {
        do {
            let encodedJson = try JSONEncoder().encode(model)
            
            guard let json = try JSONSerialization.jsonObject(with: encodedJson) as? [String : Any] else {
                print("[SwiftyFirebase] failed")
                throw EZFirestoreError.encodingFailed
            }
            
            //Identifiable
            if let model = model as? (any Identifiable) {
                db.collection(path).document(model.id as! String).setData(json, merge: true) { error in
                    if let error {
                        print("[SwiftyFirebase] failed")
                        print(error)
                    }
                    
                    completion()
                }
            } else {
                db.collection(path).addDocument(data: json) { error in
                    if let error {
                        print("[SwiftyFirebase] failed")
                        print(error)
                    }
                    
                    completion()
                }
            }
            
        } catch {
            print(error)
        }
    }
    
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
    
    static func fetch<T>(type: T.Type, path: String, id: String, completion: @escaping (T?) -> ()) where T : Decodable, T : Encodable  {
        db.collection(path).document(id).getDocument { snapshot, error in
            if let error {
                print(error)
                completion(nil)
                return
            }
            
            guard let snapshot else {
                print("🔥 EZFirestore Error : EMPTY data in the path")
                completion(nil)
                return
            }
            guard let data = snapshot.data() else {
                print("🔥 EZFirestore Error : Snapshot To Dictionary Failed")
                completion(nil)
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data)

                let model = try JSONDecoder().decode(T.self, from: jsonData)
                
                completion(model)
            } catch {
                print("🔥 EZFirestore Error : \(error.localizedDescription)")
            }
        }
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
    
    static func fetchList<T>(of: T.Type, path: String, completion: @escaping ([T]) -> ()) where T : Decodable, T : Encodable  {
        db.collection(path).getDocuments { snapshot, error in
            if let error {
                print(error)
                completion([])
                return
            }
            
            guard let snapshot else {
                print("🔥 EZFirestore Error : EMPTY data in the path")
                completion([])
                return
            }
            
            var models: [T] = []

            for data in snapshot.documents {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data.data())
                    let model = try JSONDecoder().decode(T.self, from: jsonData)
                    models.append(model)
                } catch {
                    print(error)
                }
            }
            
            completion(models)
        }
    }
}
