//
//  ProfilController.swift
//  ElectroProject
//
//  Created by Bechir Belkahla on 12/7/17.
//  Copyright © 2017 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire

class ProfilController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    
    
    let defaultValues = UserDefaults.standard
    let URL_USER = "http://\(ViewController.ipAdresse):8000/api/getUser"
    let URL_LOGOUT = "http://\(ViewController.ipAdresse):8000/api/logout"
    var filename=""
    static var userImageSaved = ""
    static var userusernameSaved = ""
    static var userTelSaved = 0
    static var userEmailSaved = ""
    let picker = UIImagePickerController()

    @IBOutlet weak var Userimage: UIImageView!
    @IBOutlet weak var txtPhone: UILabel!
    @IBOutlet weak var txtUsername: UILabel!
    @IBOutlet weak var txtEmail: UILabel!
    @IBOutlet weak var txtDateDeNaissance: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getProfil()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getProfil() {
        let token: String = defaultValues.value(forKey: "token") as! String
        
        let Auth_header    = [ "Authorization" : "bearer "+token ]
        
        
        Alamofire.request(URL_USER, method: .get , headers: Auth_header).responseJSON
            {
                response in
                let requests = response.result.value as! Array<Dictionary<String,AnyObject>>
                 //Loop through the requests
                
                for request in requests
                {
                    print(request)
                    // Get data
                    let username = request["username"] as! String
                    let email = request["email"] as! String
                    let date = request["dateDeNaissnce"] as! String
                    let image = request["image"] as! String
                    ProfilController.userImageSaved = image
                    let numTel = request["numtel"] as! Int
                    ProfilController.userTelSaved = numTel
                    ProfilController.userusernameSaved = username
                    ProfilController.userEmailSaved = email
                    
                    let replaced = image.replacingOccurrences(of: "127.0.0.1", with: ViewController.ipAdresse)
                    
                    let url = URL(string: replaced)
                    let data = try? Data(contentsOf: url!)

                    self.txtUsername.text=username
                    self.Userimage.layer.cornerRadius = self.Userimage.frame.size.width / 2;
                    self.Userimage.clipsToBounds = true;
                    self.txtEmail.text = email
                    self.txtPhone.text = String(numTel)
                    self.txtDateDeNaissance.text = date
                    self.Userimage.image = UIImage(data: data!)
                }
        }
        
    }
    
    
    
    @IBAction func logoutAction(_ sender: Any) {
        
        let token: String = ViewController.defaultValues.value(forKey: "token") as! String
        let dv = ViewController.defaultValues
        let Auth_header    = [ "Authorization" : "bearer "+token ]
        
        let parameters: Parameters=[
            "token":token
        ]
        
        
        Alamofire.request(URL_LOGOUT, method: .get , parameters: parameters , headers: Auth_header).responseJSON
            {
                response in
                dv.set(nil,forKey: "username")
                dv.set(nil,forKey: "password")
                let ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "nextViewLogin")
                self.present(ViewController, animated: false, completion: nil)
            }
    }
    
    /// Upload Image///////////////////////////////////////////////////////////////////////////////////////////
    
    @IBAction func UploadImage(_ sender: Any) {
        
        let imagepickercontroller = UIImagePickerController()
        imagepickercontroller.delegate = self
        
        let actionSheet = UIAlertController(title: "photo source", message: "choose a source", preferredStyle: .actionSheet)
        
        
       // actionSheet.popoverPresentationController?.sourceView = self.view
       // actionSheet.popoverPresentationController?.sourceRect = self.view.bounds
        // this is the center of the screen currently but it can be any point in the view
        
        actionSheet.addAction(UIAlertAction(title: "camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagepickercontroller.sourceType = .camera
                self.present(imagepickercontroller,animated: true,completion: nil)
            }else{
                print("camera not avaibale")
            }
            
            
        }))
        actionSheet.addAction(UIAlertAction(title: "photo library", style: .default, handler: { (action:UIAlertAction) in
            imagepickercontroller.sourceType = .photoLibrary
            self.present(imagepickercontroller,animated: true,completion: nil)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func myImageUploadRequest()
    {
        print("here")
        let myUrl = NSURL(string: "http://127.0.0.1/AndroidImageUpload/uploadd.php");
        //let myUrl = NSURL(string: "http://www.boredwear.com/utils/postImage.php");
        
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        //zeydine hedhouma raw
        let param = [
            "username"  : "\(String(describing: self.txtUsername.text))",
            "lastName"    : "belhadjali",
            "userId"    : "123"
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        var imageData = UIImageJPEGRepresentation(Userimage.image!, 1)
        
        if(imageData==nil)  {  print("no image"); return}
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        print("fama taswira")
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            
            
            
            
        }
        
        task.resume()
    }
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        
        
        filename = self.txtUsername.text!+".png"
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
}
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }

}

extension ProfilController {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        Userimage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        myImageUploadRequest()
        
        let URL_USER_EDIT = "http://\(ViewController.ipAdresse):8000/api/updateUser"
        
        let token: String = self.defaultValues.value(forKey: "token") as! String
        
        let Auth_header    = [ "Authorization" : "bearer "+token ]
        
       
        
        let parameters: Parameters=[
            "username":self.txtUsername.text!,
            "email":self.txtEmail.text!,
            "numtel":self.txtPhone.text!,
            "dateDeNaissance":self.txtDateDeNaissance.text!,
            "image":"http://127.0.0.1/AndroidImageUpload/uploads/\(self.txtUsername.text!).png"
            
        ]
        
        Alamofire.request(URL_USER_EDIT, method: .post ,parameters: parameters, headers: Auth_header).responseJSON
            {
                response in
                print("here")

                
        }
        
        
    }
    
    
    
    
}
