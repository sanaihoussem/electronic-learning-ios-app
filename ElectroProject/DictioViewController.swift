//
//  DictioViewController.swift
//  ElectroProject
//
//  Created by Bechir Belkahla on 1/9/18.
//  Copyright © 2018 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire

class DictioViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let URL_DATA = "http://\(ViewController.ipAdresse)/dictio.json"
    var requestsArray = [Dictio]()
    
    @IBOutlet weak var listTable: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        getTitles(lettre: "A")
        self.listTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestsArray.count
    }
    
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell4")
        let texte1Lbl = cell?.viewWithTag(101) as! UILabel
        texte1Lbl.text = requestsArray[indexPath.row].texte1
        let texte2Lbl = cell?.viewWithTag(102) as! UILabel
        texte2Lbl.text = requestsArray[indexPath.row].texte2
        
        return cell!
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func getTitles(lettre: String) {
        Alamofire.request(URL_DATA, method: .get).responseJSON
            {
                
                response in
                if let result = response.result.value as? [String:Any],
                    let main = result[lettre] as? [[String:String]] {
                    for dictio in main {
                        
                        let texte1 = dictio["texte1"] as! String
                        let texte2 = dictio["texte2"] as! String
                        
                        let request = Dictio(texte1: texte1, texte2: texte2)
                        
                        // Add to the requests array
                        self.requestsArray.append(request)
                    }
                    
                }
                
                self.listTable.reloadData()
        }
    }
    
    
    @IBAction func aCtion(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "A")
    }
    
    
    
   
    @IBAction func bAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "B")
    }
    
    @IBAction func cAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "C")
    }
    
    
    @IBAction func dAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "D")
    }
    @IBAction func eAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "E")
    }
    @IBAction func fAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "F")
    }
    @IBAction func gAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "G")
    }
    @IBAction func hAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "H")
    }
    @IBAction func iAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "I")
    }
    @IBAction func jAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "J")
    }
    @IBAction func kAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "M")
    }
    @IBAction func lAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "L")
    }
    
    @IBAction func mAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "M")
    }
    @IBAction func nAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "N")
    }
    @IBAction func oAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "O")
    }
    @IBAction func pAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "P")
    }
    @IBAction func qAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "Q")
    }
    @IBAction func rAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "R")
    }
    @IBAction func sAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "S")
    }
    @IBAction func tAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "T")
    }
    @IBAction func uAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "U")
    }
    @IBAction func vAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "V")
    }
    @IBAction func wAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "W")
    }
    @IBAction func xAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "X")
    }
    @IBAction func yAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "Y")
    }
    @IBAction func zAction(_ sender: Any) {
        self.requestsArray.removeAll()
        getTitles(lettre: "Z")
    }
}
