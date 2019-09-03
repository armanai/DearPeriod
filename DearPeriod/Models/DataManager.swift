//
//  Data.swift
//  DearPeriod
//
//  Created by Armana Imširević, Klara Raškaj on 16/11/2018.
//  Copyright © 2018 Armana Imširević, Klara Raškaj. All rights reserved.
//

import Foundation

class DataManager{
    static let shared = DataManager()
    var data: Person?
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    private let key = "PersonData"
    
    private init() {
        guard let savedPerson = UserDefaults.standard.object(forKey: key) as? Data, let loadedPerson = try? decoder.decode(Person.self, from: savedPerson) else{
            data = nil
            return
        }
        
        data = loadedPerson
    }
    
    func savePerson(person: Person){
        if let encoded = try? encoder.encode(person) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
}

