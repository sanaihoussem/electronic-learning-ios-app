//
//  CurrentUser.swift
//  ElectroProject
//
//  Created by Bechir Belkahla on 12/2/17.
//  Copyright © 2017 ESPRIT. All rights reserved.
//

import Foundation
public class CurrentUser {
    
   
    var userToken : String {
    get{
        return self.userToken
    }
    set(v){
    self.userToken = v;
    }
    }
    
    init(userToken: String) {
        
        self.userToken = userToken
    }
    
    
}

