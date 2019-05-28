//
//  ListeForumViewController.swift
//  ElectroProject
//
//  Created by Bechir Belkahla on 1/9/18.
//  Copyright © 2018 ESPRIT. All rights reserved.
//

import UIKit

class ListeForumViewController: UIViewController {
    
    var duration:String?

    @IBAction func btnElectro(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "nextCode") as! ListViewController
        nextViewController.categoriePassed = "electronique"
        ViewController.MainCategorie = "electronique"
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    @IBAction func btnRobotique(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "nextCode") as! ListViewController
        nextViewController.categoriePassed = "robotique"
        ViewController.MainCategorie = "robotique"
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func btnDomotique(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "nextCode") as! ListViewController
        nextViewController.categoriePassed = "domotique"
        ViewController.MainCategorie = "domotique"
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func btnCode(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "nextCode") as! ListViewController
        nextViewController.categoriePassed = "code"
        ViewController.MainCategorie = "code"
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func btnLog(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "nextCode") as! ListViewController
        nextViewController.categoriePassed = "logiciel"
        ViewController.MainCategorie = "logiciel"
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
