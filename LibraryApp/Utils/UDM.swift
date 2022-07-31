//
//  UDM.swift
//  LibraryApp
//
//  Created by KC on 24/06/2022.
//


import Foundation
import UIKit


extension UserDefaults{
    func valueExits (forKey key:String) -> Bool{
        return object(forKey: key) != nil
    }
}

class UDM {
    static let shared = UDM()
    let defaults = UserDefaults(suiteName: "library_app")!
    
    
}


