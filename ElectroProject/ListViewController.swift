//
//  ListViewController.swift
//  ElectroProject
//
//  Created by Bechir Belkahla on 11/16/17.
//  Copyright © 2017 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire

class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var va: Int = 1
    let defaultValues = UserDefaults.standard
    var categoriePassed:String?
    
   
    @IBOutlet weak var loading: UIImageView!
    @IBOutlet weak var listTable: UITableView!
    @IBOutlet weak var treaisty: UIImageView!
    
    let URL_TITRE = "http://\(ViewController.ipAdresse):8000/api/getQuestion"
    let URL_ADD_REPONSE = "http://\(ViewController.ipAdresse):8000/api/createReponse"
    var requestsArray = [List]()
    var someTitle = [String]()

    override func viewWillAppear(_ animated: Bool) {
        getTitles()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getTitles() {
        let token: String = defaultValues.value(forKey: "token") as! String
        
        let Auth_header    = [ "Authorization" : "bearer "+token ]
        
        
        
        
        Alamofire.request(URL_TITRE, method: .get, headers: Auth_header).responseJSON
        {
            
            response in
            
            let requests = response.result.value as! Array<Dictionary<String,AnyObject>>
            // Loop through the requests
            self.requestsArray.removeAll()
            for request in requests
            {
                var cat : String = ""
                cat=request["categorie"] as! String
                if(cat==self.categoriePassed)
                {
                // Get data
                let id = request["id"] as! Int
                let titre = request["titre"] as! String
                let categorie = request["categorie"] as! String
                let user_id = request["user_id"] as! Int
                let date_ajout = request["date_ajout"] as! String
                let description = request["description"] as! String
                let imageUser = request["user_image"] as! String
                let usernameUser = request["user_username"] as! String
                // Create a new request
                    let request = List(id: id, user_id: user_id, titre: titre, date_ajout:date_ajout,description:description, categorie: categorie, imageUser: imageUser, usernameUser: usernameUser)
                
                // Add to the requests array
                
                self.requestsArray.append(request)
                    
                }
                
            }
            self.loading.isHidden = true
            self.treaisty.isHidden = true
            
            
            self.listTable.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestsArray.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell")
        
        
        let replaced = requestsArray[indexPath.row].imageUser.replacingOccurrences(of: "127.0.0.1", with: ViewController.ipAdresse)
        
        let url = URL(string: replaced)
        let data = try? Data(contentsOf: url!)
        
        
        let titre = cell?.viewWithTag(1001) as! UILabel
        titre.text = requestsArray[indexPath.row].titre
        let date_ajout = cell?.viewWithTag(1002) as! UILabel
        date_ajout.text = requestsArray[indexPath.row].date_ajout
        let description = cell?.viewWithTag(1003) as! UILabel
        let user_image = cell?.viewWithTag(12) as! UIImageView
        let user_username = cell?.viewWithTag(13) as! UILabel
        description.text = requestsArray[indexPath.row].description
        user_username.text = requestsArray[indexPath.row].usernameUser
        user_image.image = UIImage(data: data!)
        user_image.layer.cornerRadius = user_image.frame.size.width / 2;
        user_image.clipsToBounds = true;

        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        // tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        va = requestsArray[indexPath.row].id
        
       
        
    }

    @IBAction func RetourAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "reponseSegue") {
            let reponseVC = segue.destination as! ReponseViewController
            reponseVC.idQuestion = requestsArray[(listTable.indexPathForSelectedRow?.row)!].id
            
        }
    }
    
}
