//
//  ReponseViewController.swift
//  ElectroProject
//
//  Created by Bechir Belkahla on 11/30/17.
//  Copyright © 2017 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire

class ReponseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextViewDelegate {
    
       let defaultValues = UserDefaults.standard
    
    
    @IBOutlet weak var loading: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var treasity: UIImageView!
    
    @IBOutlet weak var reponseBody: UITextView!
    @IBOutlet weak var listeTable: UITableView!

    @IBOutlet weak var resposeBodyHeightConstraint: NSLayoutConstraint!

    var idQuestion : Int = 0
    let URL_TITRE = "http://\(ViewController.ipAdresse):8000/api/getReponse"
    let URL_ADD_REPONSE = "http://\(ViewController.ipAdresse):8000/api/createReponse"
    let URL_ADD_REPONSE_VOTE = "http://\(ViewController.ipAdresse):8000/api/updateReponse"
    var requestsArray = [Reponse]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestsArray.count
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTitles()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell2")
        
        let replaced = requestsArray[indexPath.row].imageUser.replacingOccurrences(of: "127.0.0.1", with: ViewController.ipAdresse)
        
        let url = URL(string: replaced)
        let data = try? Data(contentsOf: url!)
        
        let reponse = cell?.viewWithTag(2001) as! UITextView
        let date = cell?.viewWithTag(2002) as! UILabel
        let imageLike = cell?.viewWithTag(104) as! UIImageView
        let user_image = cell?.viewWithTag(22) as! UIImageView
        let user_username = cell?.viewWithTag(23) as! UILabel
        
        reponse.text = requestsArray[indexPath.row].description
        date.text = requestsArray[indexPath.row].date_ajout
        user_username.text = requestsArray[indexPath.row].usernameUser
        user_image.image = UIImage(data: data!)
        user_image.layer.cornerRadius = user_image.frame.size.width / 2;
        user_image.clipsToBounds = true;
        
        
        if(requestsArray[indexPath.row].nbr_vote==1)
        {
            imageLike.image =   #imageLiteral(resourceName: "Check-vert")
        }
        else{ imageLike.image = #imageLiteral(resourceName: "Check-vert copyy")}
        
        return cell!
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        reponseBody.delegate = self

        reponseBody.text = "Votre Commentaire..."
        reponseBody.textColor = UIColor.lightGray

        // Do any additional setup after loading the view.
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if reponseBody.textColor == UIColor.lightGray {
            reponseBody.text = nil
            reponseBody.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if reponseBody.text.isEmpty {
            reponseBody.text = "Votre Commentaire..."
            reponseBody.textColor = UIColor.lightGray
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if size.height != resposeBodyHeightConstraint.constant && size.height > textView.frame.size.height{
            resposeBodyHeightConstraint.constant = size.height
            textView.setContentOffset(CGPoint.zero, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTitles() {
        
        let parameters: Parameters=[
            "question_id":idQuestion
        ]
        let token: String = defaultValues.value(forKey: "token") as! String
        let Auth_header    = [ "Authorization" : "bearer "+token ]
        
        Alamofire.request(URL_TITRE, method: .get, parameters: parameters, headers: Auth_header).responseJSON
            {
                response in
                print("here3")
                //print(response)
                let requests = response.result.value as! Array<Dictionary<String,AnyObject>>
                // Loop through the requests
                self.requestsArray.removeAll()
                for request in requests
                {
                    // Get data
                    let id = request["id"] as! Int
                    let description = request["body"] as! String
                    let nbr_vote = request["nbr_vote"] as! Int
                    let date_ajout = request["date_ajout"] as! String
                    let imageUser = request["user_image"] as! String
                    
                    let usernameUser = request["user_username"] as! String
                    // Create a new request
                    let request = Reponse(id: id, description: description, date_ajout: date_ajout, nbr_vote: nbr_vote, imageUser: imageUser, usernameUser: usernameUser)
                    
                    // Add to the requests array
                    self.requestsArray.append(request)
                    
                }
                self.loading.isHidden = true
                self.treasity.isHidden = true

                self.listeTable.reloadData()
        }
    }
    

    @IBAction func addAction(_ sender: Any) {
        if !reponseBody.text.isEmpty && !(reponseBody.text == "Votre Commentaire...") {
            let parameters: Parameters=[
                "body":reponseBody.text,
                "question_id":idQuestion
            ]
            let token: String = defaultValues.value(forKey: "token") as! String
            let Auth_header    = [ "Authorization" : "bearer "+token ]

            //Sending http post request
            Alamofire.request(self.URL_ADD_REPONSE, method: .post, parameters: parameters ,encoding:URLEncoding.queryString, headers: Auth_header).responseJSON
                { response in }

            //alert success
            let alert = UIAlertController(title: "Succes", message: "Votre commentaire a été ajouté", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

            //empty textView
            reponseBody.text = "Votre Commentaire..."
            reponseBody.textColor = UIColor.lightGray
            resposeBodyHeightConstraint.constant = 30
            reponseBody.endEditing(true)

            //show comments
            getTitles()
        } else {
            //alert empty
            let alert = UIAlertController(title: "Oopsie", message: "Votre message est vide!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        

        
    }
    @IBAction func returnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if(requestsArray[(listeTable.indexPathForSelectedRow?.row)!].nbr_vote==0)
        {
        
        //let va = requestsArray[indexPath.row].id
        let parameters: Parameters=[
            
            "id":requestsArray[(listeTable.indexPathForSelectedRow?.row)!].id,
            "nbr_vote":requestsArray[(listeTable.indexPathForSelectedRow?.row)!].nbr_vote+1
        ]
        
        
        let token: String = defaultValues.value(forKey: "token") as! String
        
        let Auth_header    = [ "Authorization" : "bearer "+token ]
        
        
        print(parameters)
        
        //Sending http post request
        Alamofire.request(self.URL_ADD_REPONSE_VOTE, method: .post, parameters: parameters ,encoding:URLEncoding.queryString, headers: Auth_header).responseJSON
            { response in
                
                
               self.getTitles()
                self.listeTable.reloadData()
                
                
        }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }


    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardHeight = max((notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height, (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.height)

        self.scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.frame.origin.y + keyboardHeight - 75), animated: true)
        self.scrollView.contentSize.height = self.containerView.frame.maxY + keyboardHeight
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        self.scrollView.contentSize.height = self.containerView.frame.maxY
    }
    

}
