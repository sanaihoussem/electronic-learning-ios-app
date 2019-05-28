//
//  HomeQuizViewController.swift
//  ElectroProject
//
//  Created by Bechir Belkahla on 12/14/17.
//  Copyright © 2017 ESPRIT. All rights reserved.
//

import UIKit
import AVFoundation

class HomeQuizViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var readQRCodeButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    static var parallaxEffect = UIMotionEffectGroup()
    static var backgroundView: UIView?
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add parallax effect to background image view
        HomeQuizViewController.backgroundView = backgroundImageView
     
        
        initializeSounds()
        initializeLables()
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Load score
        let answersScore = UserDefaultsManager.score
        scoreLabel.text = "🏆 \(answersScore)pts"
        
        if answersScore == 0 {
            scoreLabel.textColor = .darkGray
        } else if answersScore < 0 {
            scoreLabel.textColor = .darkRed
        } else {
            scoreLabel.textColor = .darkGreen
        }
        //loadTheme()
    }
    
   
    // MARK: UnwindSegue
    
    @IBAction func unwindToMainMenu(_ unwindSegue: UIStoryboardSegue) {
        Audio.setVolumeLevel(to: Audio.bgMusicVolume)
    }
    
    // MARK: Convenience
    
    private func initializeSounds() {
        
        
        Audio.correct = AVAudioPlayer(file: "correct", type: "mp3")
        Audio.incorrect = AVAudioPlayer(file: "incorrect", type: "wav")
        
        Audio.correct?.volume = 0.10
        Audio.incorrect?.volume = 0.25
        
    }
    
    private func initializeLables() {
        startButton.setTitle("COMMENCER QUIZ".localized, for: .normal)
        readQRCodeButton.setTitle("AIDE".localized, for: .normal)
        settingsButton.setTitle("STATISTIQUE".localized, for: .normal)
    }
   

}
