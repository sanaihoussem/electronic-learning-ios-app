//
//  TabBarController.swift
//  ElectroProject
//
//  Created by Lilia Belkahla on 11/01/2018.
//  Copyright © 2018 ESPRIT. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UINavigationControllerDelegate, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let morenavbar = navigationController.navigationBar
        if let morenavitem = morenavbar.topItem {
            morenavitem.rightBarButtonItem?.style = .done
        }
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
