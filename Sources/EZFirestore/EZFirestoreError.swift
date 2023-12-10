//
//  File.swift
//  
//
//  Created by 박진서 on 12/10/23.
//

import Foundation

extension EZFirestore {
    enum EZFirestoreError: Error {
        case encodingFailed
        case snapshotToDictionaryFailed
    }
}

