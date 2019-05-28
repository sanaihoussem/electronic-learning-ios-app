//
//  Reponse.swift
//  ElectroProject
//
//  Created by Houcem Sanai on 02/12/2017.
//  Copyright © 2017 ESPRIT. All rights reserved.
//

import Foundation
public class Reponse {
    
    var id : Int
    var user_id : Int
    var date_ajout : String = ""
    var description : String = ""
    var nbr_vote : Int
    var imageUser : String = ""
    var usernameUser : String = ""
    
    /*init(id: Int, user_id: Int, titre: String, date_ajout: String, description: String, categorie: String) {
        self.id = id
        self.titre = titre
        self.user_id = user_id
        self.date_ajout = date_ajout
        self.description = description
        self.categorie = categorie
    }*/
    
    init(id: Int, description: String, date_ajout: String, nbr_vote:Int, imageUser: String, usernameUser: String) {
        self.id = id
        self.user_id = 1
        self.date_ajout = date_ajout
        self.description = description
        self.nbr_vote = nbr_vote
        self.imageUser = imageUser
        self.usernameUser = usernameUser
    }
}

