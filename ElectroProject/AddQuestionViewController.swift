//
//  AddQuestionViewController.swift
//  ElectroProject
//
//  Created by Bechir Belkahla on 11/16/17.
//  Copyright © 2017 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire

class AddQuestionViewController: UIViewController, UITextViewDelegate {
    let defaultValues = UserDefaults.standard

    @IBOutlet weak var titreTxt: UITextField!
    @IBOutlet weak var descriptionTxt: UITextView!
    
    @IBOutlet weak var descriptionTextFieldHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.descriptionTxt.delegate = self
        descriptionTxt.text = "Description.."
        descriptionTxt.textColor = UIColor.lightGray

        let toolbarDone = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbarDone.barStyle = UIBarStyle.default
        toolbarDone.items = [
            UIBarButtonItem(title: NSLocalizedString("Ok", comment: ""), style: UIBarButtonItemStyle.done, target: self, action: #selector(dismissKeyboard))
        ]
        toolbarDone.sizeToFit()

        titreTxt.inputAccessoryView = toolbarDone
        descriptionTxt.inputAccessoryView = toolbarDone
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTxt.textColor == UIColor.lightGray {
            descriptionTxt.text = nil
            descriptionTxt.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTxt.text.isEmpty {
            descriptionTxt.text = "Description.."
            descriptionTxt.textColor = UIColor.lightGray
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if size.height != descriptionTextFieldHeightConstraint.constant && size.height > textView.frame.size.height{
            descriptionTextFieldHeightConstraint.constant = size.height
            textView.setContentOffset(CGPoint.zero, animated: false)
        }
    }

    @IBAction func retourAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    let URL_QUESTION_ADD = "http://\(ViewController.ipAdresse):8000/api/createQuestion"

    @IBAction func envoyerBtn(_ sender: Any) {
        
        if((titreTxt.text?.isEmpty) != true && (descriptionTxt.text?.isEmpty) != true && descriptionTxt.text != "Description..")
        {

        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)

        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        let time = String(year!)+"-"+String(month!)+"-"+String(day!)+"-"+String(hour!)+"-"+String(minute!)+"-"+String(second!)



        let parameters: Parameters=[
            "titre":titreTxt.text!,
            "categorie":ViewController.MainCategorie,
            "description":descriptionTxt.text!
        ]



        let token: String = defaultValues.value(forKey: "token") as! String

        let Auth_header    = [ "Authorization" : "bearer "+token ]






        //Sending http post request
        Alamofire.request(URL_QUESTION_ADD, method: .post, parameters: parameters ,encoding:URLEncoding.queryString, headers: Auth_header).responseJSON
            { response in

                //print(response)
                //getting the json value from the server


        }
        self.dismiss(animated: true, completion: nil)
    }
    
    else{
    let alertController = UIAlertController(title: "Erreur", message: "tous les champs sont obligatoires", preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(defaultAction)
    
    self.present(alertController, animated: true, completion: nil)
    }
    }

}
