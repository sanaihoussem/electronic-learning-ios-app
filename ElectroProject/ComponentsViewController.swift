//
//  ComponentsViewController.swift
//  ElectroProject
//
//  Created by Houcem Sanai on 11/01/2018.
//  Copyright © 2018 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire

class ComponentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var name: String = ""
    let URL_DATA = "http://\(ViewController.ipAdresse)/data.json"
    var requestsArray = [Composant]()
    
    override func viewWillAppear(_ animated: Bool) {
        getTitles()
        print("list size ====> \(requestsArray.count)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
        cell.componentLbl.text = requestsArray[indexPath.row].titre
        let replaced = requestsArray[indexPath.row].imageURL.replacingOccurrences(of: "127.0.0.1", with: ViewController.ipAdresse)
        let url = URL(string: replaced)
        let data = try? Data(contentsOf: url!)
        cell.componentImage.image = UIImage(data: data!)
        cell.componentImage.layer.cornerRadius = cell.componentImage.frame.height / 2
        
        return cell
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
        print("here to camp")
        Alamofire.request(URL_DATA, method: .get).responseJSON
            {
                
                response in
                
                if let result = response.result.value as? [String:Any],
                    let main = result[self.name] as? [[String:String]] {
                    
                    // main[0]["USDARS"] or use main.first?["USDARS"] for first index or loop through array
                    for composant in main {
                        
                        let titre = composant["titre"]
                        let description = composant["description"]
                        let imageURL = composant["image"]
                        
                        let request = Composant(titre: titre!, description: description!, imageURL: imageURL!)
                        
                        // Add to the requests array
                        self.requestsArray.append(request)
                    }
                    
                }
                
                self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.requestsArray.removeAll()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "componentDetails") {
            
            let reponseVC = segue.destination as! DetailsComposantViewController
            reponseVC.composantTitre = requestsArray[(tableView.indexPathForSelectedRow?.row)!].titre
            reponseVC.composantDesc = requestsArray[(tableView.indexPathForSelectedRow?.row)!].description
            reponseVC.composantImage = requestsArray[(tableView.indexPathForSelectedRow?.row)!].imageURL
            print(requestsArray[(tableView.indexPathForSelectedRow?.row)!].titre)
            
        }
    }
    

    @IBAction func retourAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

