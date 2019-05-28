//
//  List.swift
//  ElectroProject
//
//  Created by Bechir Belkahla on 11/16/17.
//  Copyright © 2017 ESPRIT. All rights reserved.
//

import Foundation
public class List {
    
    var id : Int
    var user_id : Int
    var titre : String = ""
    var date_ajout : String = ""
    var categorie : String = ""
    var description : String = ""
    var imageUser : String = ""
    var usernameUser : String = ""
  
    init(id: Int, user_id: Int, titre: String, date_ajout: String, description: String, categorie: String
        , imageUser: String, usernameUser: String) {
        
        self.id = id
        self.titre = titre
        self.user_id = user_id
        self.date_ajout = date_ajout
        self.description = description
        self.categorie = categorie
        self.imageUser = imageUser
        self.usernameUser = usernameUser
        }

}
