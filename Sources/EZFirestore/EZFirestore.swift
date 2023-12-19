//
//  File.swift
//  
//
//  Created by 박진서 on 12/10/23.
//

import FirebaseFirestore

public class EZFirestore: EZFirestoreType {

    static private let db = Firestore.firestore()
    
    public static func save(model: Codable, path: String, completion: @escaping () -> ()) {
        do {
            let encodedJson = try JSONEncoder().encode(model)
            
            guard let json = try JSONSerialization.jsonObject(with: encodedJson) as? [String : Any] else {
                print("[EZFirebase] failed")
                throw EZFirestoreError.encodingFailed
            }
            
            //Identifiable
            if let model = model as? (any Identifiable) {
                db.collection(path).document(model.id as! String).setData(json, merge: true) { error in
                    if let error {
                        print("[EZFirebase] failed")
                        print(error)
                    }
                    
                    completion()
                }
            } else {
                db.collection(path).addDocument(data: json) { error in
                    if let error {
                        print("[EZFirebase] failed")
                        print(error)
                    }
                    
                    completion()
                }
            }
            
        } catch {
            print(error)
        }
    }
    
    public static func save(model: Codable, path: String) async throws {
        let encodedJson = try JSONEncoder().encode(model)
        
        guard let json = try JSONSerialization.jsonObject(with: encodedJson) as? [String : Any] else {
            print("[EZFirebase] failed")
            throw EZFirestoreError.encodingFailed
        }
        
        //Identifiable
        if let model = model as? (any Identifiable) {
            try await db.collection(path).document(model.id as! String).setData(json, merge: true)
        } else {
            try await db.collection(path).addDocument(data: json)
        }
    }
    
    public static func fetch<T: Codable>(type: T.Type, path: String, id: String) async throws -> T {
        let snapshot = try await db.collection(path).document(id).getDocument()
        guard let data = snapshot.data() else {
            throw EZFirestoreError.snapshotToDictionaryFailed
        }
        let jsonData = try JSONSerialization.data(withJSONObject: data)

        let model = try JSONDecoder().decode(T.self, from: jsonData)
        
        return model
    }
    
    static func fetch<T>(type: T.Type, path: String, id: String, completion: @escaping (T?) -> ()) where T : Decodable, T : Encodable {
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

    public static func fetchList<T: Codable>(of: T.Type, path: String, last: String, orderBy: String, limit: Int = 20) async throws -> [T] {
        let snapshots = try await db.collection(path).whereField(orderBy, isGreaterThan: last).limit(to: limit).getDocuments()

        var models: [T] = []
        
        for snapshot in snapshots.documents {
            let data = snapshot.data()
            
            let jsonData = try JSONSerialization.data(withJSONObject: data)

            let model = try JSONDecoder().decode(T.self, from: jsonData)
            models.append(model)
        }
        
        return models
    }
    
    public static func fetchList<T>(of: T.Type, path: String, completion: @escaping ([T]) -> ()) where T : Decodable, T : Encodable {
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
    
    public static func fetchWithFilter<T>(of: T.Type, path: String, filters: Filter, last: String, orderBy: String, limit: Int = 20) async throws -> [T] where T : Decodable, T : Encodable {
        
        let snapshots = try await db.collection(path).whereFilter(filters).getDocuments()
        
        var models: [T] = []
        
        for snapshot in snapshots.documents {
            let data = snapshot.data()
            
            let jsonData = try JSONSerialization.data(withJSONObject: data)

            let model = try JSONDecoder().decode(T.self, from: jsonData)
            models.append(model)
        }
        
        return models
    }
    
    public static func search<T>(of: T.Type, path: String, key: String, keyword: String, last: String, orderBy: String, limit: Int = 20) async throws -> [T] where T : Decodable, T : Encodable {

        let snapshots = try await db.collection(path).whereField(key, isGreaterThanOrEqualTo: keyword).whereField(orderBy, isGreaterThan: last).limit(to: limit).getDocuments()
        
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
