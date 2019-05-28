//
//  AppDelegate.swift
//  ElectroProject
//
//  Created by Bechir Belkahla on 11/8/17.
//  Copyright © 2017 ESPRIT. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var wasPlaying = Bool()
    
    
    // Home Screen Quick Actions [3D Touch]
    
    enum ShortcutItemType: String {
        case QRCode
        case DarkTheme
        case LightTheme
    }
    
    static var windowReference: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UserDefaultsManager.loadDefaultValues()
        
        // Load configuration file (if it doesn't exist it creates a new one when the app goes to background)
        if let mySettings = NSKeyedUnarchiver.unarchiveObject(withFile: DataStore.path) as? DataStore {
            DataStore.shared = mySettings
        }
        
        Topic.loadSets()
        
        //
        AppDelegate.windowReference = self.window
        
        let navController = window?.rootViewController as? UINavigationController
        if #available(iOS 11.0, *) {
            navController?.navigationBar.prefersLargeTitles = true
        }
        if #available(iOS 9.0, *) {
            
            let readQRCode = UIMutableApplicationShortcutItem(type: ShortcutItemType.QRCode.rawValue,
                                                              localizedTitle: "Scan QR Code".localized,
                                                              localizedSubtitle: nil,
                                                              icon: UIApplicationShortcutIcon(templateImageName: "QRCodeIcon"))
            
            let darkTheme = UIMutableApplicationShortcutItem(type: ShortcutItemType.DarkTheme.rawValue,
                                                             localizedTitle: "Dark Theme".localized,
                                                             localizedSubtitle: nil,
                                                             icon: UIApplicationShortcutIcon(templateImageName: "DarkThemeIcon"))
            
            let lightTheme = UIMutableApplicationShortcutItem(type: ShortcutItemType.LightTheme.rawValue,
                                                              localizedTitle: "Light Theme".localized,
                                                              localizedSubtitle: nil,
                                                              icon: UIApplicationShortcutIcon(templateImageName: "LightThemeIcon"))
            
            application.shortcutItems = [readQRCode, darkTheme, lightTheme]
        }
        
        AppDelegate.updateVolumeBarTheme()
        VolumeBar.shared.start()
        
        self.window?.dontInvertIfDarkModeIsEnabled()
        return true
    }
    
    
    static func updateVolumeBarTheme() {
        VolumeBar.shared.backgroundColor = .themeStyle(dark: .veryVeryDarkGray, light: .white)
        VolumeBar.shared.tintColor = .themeStyle(dark: .lightGray, light: .black)
        VolumeBar.shared.trackTintColor = .themeStyle(dark: UIColor.lightGray.withAlphaComponent(0.3), light: UIColor.black.withAlphaComponent(0.1))
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        if let itemType = ShortcutItemType(rawValue: shortcutItem.type) {
            
            switch itemType {
                
            case .QRCode:
                if let questionsVC = window?.rootViewController?.presentedViewController as? QuestionsViewController {
                    questionsVC.performSegue(withIdentifier: "unwindToMainMenu", sender: self)
                }
                if let presentedViewController = window?.rootViewController as? UINavigationController {
                    
                    if presentedViewController.topViewController is QRScannerViewController {
                        return
                    } else if !(presentedViewController.topViewController is HomeQuizViewController) {
                        presentedViewController.popToRootViewController(animated: false)
                    }
                    presentedViewController.topViewController?.performSegue(withIdentifier: "QRScannerVC", sender: self)
                }
                else if (window?.rootViewController == nil) {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let viewController = storyboard.instantiateViewController(withIdentifier: "HomeQuizViewController") as? HomeQuizViewController {
                        
                        let navController = UINavigationController(rootViewController: viewController)
                        if #available(iOS 11.0, *) {
                            navController.navigationBar.prefersLargeTitles = true
                        }
                        
                        window?.rootViewController?.present(navController, animated: false)
                        
                        viewController.performSegue(withIdentifier: "QRScannerVC", sender: self)
                    }
                }
                
            case .DarkTheme:
                UserDefaultsManager.darkThemeSwitchIsOn = true
                AppDelegate.updateVolumeBarTheme()
                
            case .LightTheme:
                UserDefaultsManager.darkThemeSwitchIsOn = false
                AppDelegate.updateVolumeBarTheme()
            }
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        if Audio.bgMusic?.isPlaying ?? false {
            Audio.bgMusic?.pause()
            wasPlaying = true
        }
        else {
            wasPlaying = false
        }
        
        guard DataStore.shared.save() else {    print("Error saving settings"); return }
        
        self.window?.dontInvertIfDarkModeIsEnabled()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        if wasPlaying {
            Audio.bgMusic?.play()
        }
        
        self.window?.dontInvertIfDarkModeIsEnabled()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ElectroProject")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

