//
//  DetailsComposantViewController.swift
//  ElectroProject
//
//  Created by Bechir Belkahla on 12/1/17.
//  Copyright © 2017 ESPRIT. All rights reserved.
//

import UIKit

class DetailsComposantViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titreLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    var composantTitre: String = ""
    var composantDesc: String = ""
    var composantImage: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       titreLbl.text = composantTitre
        descLbl.text = composantDesc
        descLbl.numberOfLines = 0
        descLbl.sizeToFit()

        
        let replaced = composantImage.replacingOccurrences(of: "127.0.0.1", with: ViewController.ipAdresse)
        let url = URL(string: replaced)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        image.image = UIImage(data: data!)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
