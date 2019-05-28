//
//  Composant.swift
//  ElectroProject
//
//  Created by Bechir Belkahla on 12/1/17.
//  Copyright © 2017 ESPRIT. All rights reserved.
//

import Foundation
public class Composant {
    
    var titre : String = ""
    var description : String = ""
    var imageURL : String = ""
    
    init( titre: String, description: String, imageURL: String) {
        self.description = description
        self.titre = titre
        self.imageURL = imageURL
    }
    
}

