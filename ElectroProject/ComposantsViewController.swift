//
//  ComposantsViewController.swift
//  ElectroProject
//
//  Created by Bechir Belkahla on 12/1/17.
//  Copyright © 2017 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire

class ComposantsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var name: String = ""
    
    let URL_DATA = "http://\(ViewController.ipAdresse)/data.json"
    var requestsArray = [Composant]()
    
    override func viewWillAppear(_ animated: Bool) {
        getTitles()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestsArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell3")
        
        let reponse = cell?.viewWithTag(102) as! UILabel
        reponse.text = requestsArray[indexPath.row].titre
        let image = cell?.viewWithTag(103) as! UIImageView
        
        let replaced = requestsArray[indexPath.row].imageURL.replacingOccurrences(of: "127.0.0.1", with: ViewController.ipAdresse)
        let url = URL(string: replaced)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        image.image = UIImage(data: data!)
        return cell!
    }
    

    @IBOutlet weak var listTable: UITableView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTitles() {
        Alamofire.request(URL_DATA, method: .get).responseJSON
            {
                
                response in
                if let result = response.result.value as? [String:Any],
                    let main = result[self.name] as? [[String:String]] {
                    // main[0]["USDARS"] or use main.first?["USDARS"] for first index or loop through array
                    for composant in main {
                        
                        let titre = composant["titre"] as! String
                        let description = composant["description"] as! String
                        let imageURL = composant["image"] as! String
                        
                        let request = Composant(titre: titre, description: description, imageURL: imageURL)
                        
                        // Add to the requests array
                        self.requestsArray.append(request)
                    }
                    
                }
                
              self.listTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
            self.requestsArray.removeAll()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailsSegue") {
            
            let reponseVC = segue.destination as! DetailsComposantViewController
            reponseVC.composantTitre = requestsArray[(listTable.indexPathForSelectedRow?.row)!].titre
            reponseVC.composantDesc = requestsArray[(listTable.indexPathForSelectedRow?.row)!].description
            reponseVC.composantImage = requestsArray[(listTable.indexPathForSelectedRow?.row)!].imageURL
            print(requestsArray[(listTable.indexPathForSelectedRow?.row)!].titre)
            
        }
    }
    
    
    
    @IBAction func retourAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

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
