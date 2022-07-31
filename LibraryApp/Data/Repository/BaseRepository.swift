//
//  BaseRepository.swift
//  LibraryApp
//
//  Created by KC on 16/06/2022.
//

import Foundation
import RealmSwift

class BaseRepository: NSObject {
    //let db = TempDatabase.shared
    let realmDB = try! Realm()
    
    override init(){
        super.init()
        print("Default Realm is at \(realmDB.configuration.fileURL?.absoluteString ?? "undefined")")
    }
}


enum MDBError : Error {
    case withMessage(String)
}

