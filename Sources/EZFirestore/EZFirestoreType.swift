//
//  File.swift
//  
//
//  Created by 박진서 on 12/10/23.
//

import Foundation
import Firebase

protocol EZFirestoreType {
    static func save(model: Codable, path: String, completion: @escaping () -> ())
    
    static func save(model: Codable, path: String) async throws -> ()
    
    static func fetch<T: Codable>(type: T.Type, path: String, id: String) async throws -> T
    
    static func fetch<T: Codable>(type: T.Type, path: String, id: String, completion: @escaping (T?) -> ())
    
    static func fetchList<T: Codable>(of: T.Type, path: String, last: String, orderBy: String, limit: Int) async throws -> [T]

    static func fetchList<T: Codable>(of: T.Type, path: String, completion: @escaping ([T]) -> ())
    
    static func fetchWithFilter<T: Codable>(of: T.Type, path: String, filters: Filter, last: String, orderBy: String, limit: Int) async throws -> [T]
}
