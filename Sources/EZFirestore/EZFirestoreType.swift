//
//  File.swift
//  
//
//  Created by 박진서 on 12/10/23.
//

import Foundation

protocol EZFirestoreType {
    @available(iOS 13.0.0, *)
    static func save(model: Codable, path: String, completion: @escaping () -> ())
    
    @available(iOS 13.0.0, *)
    static func save(model: Codable, path: String) async throws -> ()
    
    @available(iOS 13.0.0, *)
    static func fetch<T: Codable>(type: T.Type, path: String, id: String) async throws -> T
    
    static func fetch<T: Codable>(type: T.Type, path: String, id: String, completion: @escaping (T?) -> ())
    
    @available(iOS 13.0.0, *)
    static func fetchList<T: Codable>(of: T.Type, path: String) async throws -> [T]
    
    static func fetchList<T: Codable>(of: T.Type, path: String, completion: @escaping ([T]) -> ())
}
