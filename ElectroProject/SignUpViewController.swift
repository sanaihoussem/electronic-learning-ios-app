//
//  SignUpViewController.swift
//  ElectroProject
//
//  Created by Bechir Belkahla on 11/13/17.
//  Copyright © 2017 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController {
    var listTitre : [[String : String]] = [[String : String]]()

    let URL_USER_REGISTER = "http://\(ViewController.ipAdresse):8000/api/register"
    let URL_API = "https://devru-instructables.p.mashape.com/list"
    let URL_TITRE = "http://\(ViewController.ipAdresse)/treasity/v1/getQuestion.php"
    
    @IBAction func returAction(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var txtTel: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var txtDate: UIDatePicker!
    @IBOutlet weak var txtNom: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @IBAction func SignUpAction(_ sender: Any) {

        if((txtNom.text?.isEmpty) != true)
        {

            if((txtPassword.text?.isEmpty) != true)
            {
                if((txtTel.text?.isEmpty) != true)
                {
                    if((txtemail.text?.isEmpty) != true)
                    {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yy"
                        let dateString = dateFormatter.string(from: txtDate.date)

                        let parameters: Parameters=[
                            "username":txtNom.text!,
                            "email":txtemail.text!,
                            "numtel":txtTel.text!,
                            "password":txtPassword.text!,
                            "image":"http://127.0.0.1/AndroidImageUpload/uploads/avatar2.png",
                            "dateDeNaissnce":dateString


                        ]


                        print(parameters)

                        let headers: HTTPHeaders = [
                            "Authorization": "Info XXX",
                            "Accept": "application/json",
                            "Content-Type" :"application/json"
                        ]


                        //Sending http post request
                        Alamofire.request(URL_USER_REGISTER, method: .post, parameters: parameters,encoding:URLEncoding.queryString, headers: headers).responseJSON
                            {
                                response in
                                //printing response
                                print(response)

                        }

                        let alert = UIAlertController(title: "Ok", message: "Creation terminé", preferredStyle: UIAlertControllerStyle.alert)

                        alert.addAction(UIAlertAction(title: "Le compte a été crée", style: UIAlertActionStyle.default, handler: { action in

                            let ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "nextViewLogin")

                            self.present(ViewController, animated: false, completion: nil)

                        }))
                        self.present(alert, animated: true, completion: nil)



                    }
                    else
                    {
                        let alertController = UIAlertController(title: "Erreur", message: "Email obligatoire", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertController.addAction(defaultAction)

                        self.present(alertController, animated: true, completion: nil)
                    }

                }
                else
                {
                    let alertController = UIAlertController(title: "Erreur", message: "Telephone obligatoire", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(defaultAction)

                    self.present(alertController, animated: true, completion: nil)
                }

            }
            else
            {
                let alertController = UIAlertController(title: "Erreur", message: "password obligatoire", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(defaultAction)

                self.present(alertController, animated: true, completion: nil)
            }


        }
        else
        {
            let alertController = UIAlertController(title: "Erreur", message: "username obligatoire", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(defaultAction)

            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardHeight = max((notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height, (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.height)

        self.scrollView.setContentOffset(CGPoint(x: 0, y: self.txtemail.frame.origin.y - 120), animated: true)
        self.scrollView.contentSize.height = self.containerView.frame.maxY + keyboardHeight
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        self.scrollView.contentSize.height = self.containerView.frame.maxY
    }

}
