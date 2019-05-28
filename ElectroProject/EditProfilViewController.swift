//
//  EditProfilViewController.swift
//  ElectroProject
//
//  Created by Bechir Belkahla on 12/8/17.
//  Copyright © 2017 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire

class EditProfilViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtTel: UITextField!
    @IBOutlet weak var txtDate: UIDatePicker!
    
    let defaultValues = UserDefaults.standard
    let URL_USER_EDIT = "http://\(ViewController.ipAdresse):8000/api/updateUser"

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        txtUsername.text = ProfilController.userusernameSaved
        txtEmail.text = ProfilController.userEmailSaved
        txtTel.text = String(ProfilController.userTelSaved)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func returnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editProfilAction(_ sender: Any) {
        
        if((txtUsername.text?.isEmpty) != true && (txtEmail.text?.isEmpty) != true && (txtTel.text?.isEmpty) != true)
        {
        
        let alertController = UIAlertController(title: "Confirmez vous votre modification", message: "", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OUI", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            
            let token: String = self.defaultValues.value(forKey: "token") as! String
            
            let Auth_header    = [ "Authorization" : "bearer "+token ]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            let dateString = dateFormatter.string(from: self.txtDate.date)
            
            let parameters: Parameters=[
                "username":self.txtUsername.text!,
                "email":self.txtEmail.text!,
                "numtel":self.txtTel.text!,
                "dateDeNaissance":dateString,
                "image":ProfilController.userImageSaved
                
            ]
            
            Alamofire.request(self.URL_USER_EDIT, method: .post ,parameters: parameters, headers: Auth_header).responseJSON
                {
                    response in
                    
            }
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
        // Add the actions
        let cancelAction = UIAlertAction(title: "NON", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
        
        }
        else
        {
            let alertController = UIAlertController(title: "Erreur", message: "Tous les champs sont obligatoires", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    //////

    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardHeight = max((notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height, (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.height)

        self.scrollView.setContentOffset(CGPoint(x: 0, y: self.txtUsername.frame.origin.y - 50), animated: true)
        self.scrollView.contentSize.height = self.viewContainer.frame.maxY + keyboardHeight
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        self.scrollView.contentSize.height = self.viewContainer.frame.maxY
    }

}
