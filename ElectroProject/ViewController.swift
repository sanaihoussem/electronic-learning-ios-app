//
//  ViewController.swift
//  ElectroProject
//
//  Created by Bechir Belkahla on 11/8/17.
//  Copyright © 2017 ESPRIT. All rights reserved.
//
import Foundation
import UIKit
import Alamofire

class ViewController: UIViewController, UIScrollViewDelegate {
    
    static var defaultValues = UserDefaults.standard
    
    static var ipAdresse = "192.168.1.7"
    static var MainCategorie = ""
    let URL_LOGIN = "http://\(ipAdresse):8000/api/login"
    
    
    

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var usernameTv: UITextField!
    @IBOutlet weak var passwordTv: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        if( ViewController.defaultValues.string(forKey: "username") == nil  ){
            print("nothing to show")
        }
        else{
            let MenuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuTabController")
            self.present(MenuViewController, animated: false, completion: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func connexionAction(_ sender: Any) {
        
        let parameters: Parameters=[
            "username":usernameTv.text!,
            "password":passwordTv.text!
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Info XXX",
            "Accept": "application/json",
            "Content-Type" :"application/json"
        ]
        
        //Sending http post request
        Alamofire.request(URL_LOGIN, method: .post, parameters: parameters,encoding:URLEncoding.queryString, headers: headers).responseJSON
            {
                response in
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    let result: Bool = jsonData.value(forKey: "success") as! Bool
                    if(result == true)
                    {
                        let token: String = jsonData.value(forKey: "token") as! String
                        ViewController.defaultValues.set( token, forKey: "token")
                        ViewController.defaultValues.set(self.usernameTv.text, forKey: "username")
                        ViewController.defaultValues.set(self.passwordTv.text, forKey: "password")
                        let MenuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuTabController")

                        self.present(MenuViewController, animated: false, completion: nil)
                    }
                    else{
                        let alertController = UIAlertController(title: "Erreur", message: "Vérifiez votre pseudo / mot de passe", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertController.addAction(defaultAction)

                        self.present(alertController, animated: true, completion: nil)
                    }
                }
        }
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardHeight = max((notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height, (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.height)

        self.scrollView.setContentOffset(CGPoint(x: 0, y: self.usernameTv.frame.origin.y - 50), animated: true)
        self.scrollView.contentSize.height = self.containerView.frame.maxY + keyboardHeight
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        self.scrollView.contentSize.height = self.containerView.frame.maxY
    }
    
}

