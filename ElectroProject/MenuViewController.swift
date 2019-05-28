//
//  MenuViewController.swift
//  ElectroProject
//
//  Created by Bechir Belkahla on 11/23/17.
//  Copyright © 2017 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire


class MenuViewController: UIViewController {
    
    
    

    
    
    @IBAction func data7Action(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "componentDetails") as! ComponentsViewController
        nextViewController.name = "Circuits intégrés"
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func data6Action(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "componentDetails") as! ComponentsViewController
        nextViewController.name = "Communication"
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func data5Action(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "componentDetails") as! ComponentsViewController
        nextViewController.name = "Moteurs"
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func data4Action(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "componentDetails") as! ComponentsViewController
        nextViewController.name = "Senseurs, capteurs, détecteurs"
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func data3Action(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "componentDetails") as! ComponentsViewController
        nextViewController.name = "Affichages et son"
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func data2Action(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "componentDetails") as! ComponentsViewController
        nextViewController.name = "Entrees et commande"
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
    @IBAction func dataAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "componentDetails") as! ComponentsViewController
        nextViewController.name = "Composants internes"
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
    @IBAction func btnForum(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
