import UIKit

class QuestionsViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!
    
    var answerButtons: [UIButton] {
        return [answer1Button, answer2Button, answer3Button, answer4Button]
    }
    @IBOutlet weak var remainingQuestionsLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var pauseView: UIView!
    @IBOutlet weak var goBack: UIButton!
    @IBOutlet weak var mainMenu: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    let oldScore = UserDefaultsManager.score
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    var blurViewPos = Int()
    var correctAnswer = UInt8()
    var correctAnswers = Int()
    var incorrectAnswers = Int()
    var repeatTimes = UInt8()
    var currentTopicIndex = Int()
    var currentSetIndex = Int()
    var isSetFromJSON = false
    var set: [QuestionType] = []
    var quiz: EnumeratedIterator<IndexingIterator<Array<QuestionType>>>!
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if !isSetFromJSON {
            setUpQuiz()
        } else {
            set.shuffle()
            quiz = set.enumerated().makeIterator()
        }

        goBack.setTitle("Menu des questions ".localized, for: .normal)
        mainMenu.setTitle("Menu principal".localized, for: .normal)
        pauseButton.setTitle("Pause".localized, for: .normal)
        pauseView.isHidden = true
        blurView.isHidden = true
   
   
        if UserDefaultsManager.score < 5 {
            helpButton.alpha = 0.4
        }
        
        pickQuestion()
    }
    
    @available(iOS, deprecated: 9.0)
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: UIResponder
    
    // If user shake the device, an alert to repeat the quiz pop ups
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        guard motion == .motionShake else { return }
        
        let currentQuestion = Int(String(remainingQuestionsLabel.text?.first ?? "0")) ?? 0
        
        FeedbackGenerator.impactOcurredWith(style: .medium)
        
        if repeatTimes < 2 && currentQuestion > 1 {
            
            let alertViewController = UIAlertController(title: "Repeter?".localized,
                                                        message: "Voulez vous reessayer encore une fois?".localized,
                                                        preferredStyle: .alert)
            
            alertViewController.addAction(title: "OK".localized, style: .default) { action in self.repeatActionDetailed() }
            alertViewController.addAction(title: "Cancel".localized, style: .cancel)
            
            present(alertViewController, animated: true)
        }
        else if repeatTimes >= 2 {
            showOKAlertWith(title: "Attention", message: "Maximum d'aides atteint")
        }
    }
    
    // MARK: UIViewController
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .themeStyle(dark: .lightContent, light: .default)
    }
    
    // MARK: UIStoryboardSegue Handling
    
    @IBAction func unwindToQuestions(_ segue: UIStoryboardSegue) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToQRScanner" {
            Audio.setVolumeLevel(to: Audio.bgMusicVolume)
        }
    }
    
    // MARK: Actions
    
    @IBAction func tapAnyWhereToClosePauseMenu(_ sender: UITapGestureRecognizer) {
        if !pauseView.isHidden {
            self.pauseMenuAction()
        }
    }
    
    @IBAction func answer1Action() { verify(answer: 0) }
    @IBAction func answer2Action() { verify(answer: 1) }
    @IBAction func answer3Action() { verify(answer: 2) }
    @IBAction func answer4Action() { verify(answer: 3) }
    
    @IBAction func pauseMenu() {
        self.pauseMenuAction()
    }
    
    @IBAction func goBackAction() {
        if !isSetFromJSON {
            performSegue(withIdentifier: "unwindToQuizSelector", sender: self)
        } else {
            performSegue(withIdentifier: "unwindToQRScanner", sender: self)
        }
    }
    
    @IBAction func helpAction() {
        
        FeedbackGenerator.impactOcurredWith(style: .light)
        
        if UserDefaultsManager.score < 5 {
            showOKAlertWith(title: "Attention", message: "Pas des points suffisants(Besoin de 5)")
        }
        else {
            
            var timesUsed: UInt8 = 0
            answerButtons.forEach { if $0.alpha != 1.0 { timesUsed += 1 } }
            
            if timesUsed < 2 {
                
                UserDefaultsManager.score -= 5
                
                var randomQuestionIndex = UInt32()
                
                repeat {
                    randomQuestionIndex = arc4random_uniform(4)
                } while((UInt8(randomQuestionIndex) == correctAnswer) || (answerButtons[Int(randomQuestionIndex)].alpha != 1.0))
                
                UIView.animate(withDuration: 0.4) {
                    
                    self.answerButtons[Int(randomQuestionIndex)].alpha = 0.4
                    
                    if (UserDefaultsManager.score < 5) || (timesUsed == 1) {
                        self.helpButton.alpha = 0.4
                    }
                }
            }
            else {
                showOKAlertWith(title: "Attention", message: "Maximum d'aides atteint")
            }
        }
    }
    
   
    
    // MARK: Convenience
    
    private func pauseMenuAction(animated: Bool = true) {
        
        let duration: TimeInterval = animated ? 0.2 : 0.0
        let title = (pauseView.isHidden) ? "Continuer" : "Pause"
        pauseButton.setTitle(title.localized, for: .normal)
        
        UIView.transition(with: self.view, duration: duration, options: [.transitionCrossDissolve], animations: {
            self.pauseView.isHidden = !self.pauseView.isHidden
            self.blurView.isHidden = !self.blurView.isHidden
        })
        
        let newVolume = (pauseView.isHidden) ? Audio.bgMusicVolume : (Audio.bgMusicVolume / 5.0)
        Audio.setVolumeLevel(to: newVolume)
    }
    
    private func shuffledQuiz(_ name: Quiz) -> NSArray{
        if currentSetIndex < name.quiz.count {
            return name.quiz[currentSetIndex].shuffled() as NSArray
        }
        return NSArray()
    }
    
 
    
   
    
    @IBAction func showPauseMenu() {
        if !pauseView.isHidden {
            pauseMenuAction(animated: false)
        }
    }
    
    public func pickQuestion() {
        
        // Restore
        UIView.animate(withDuration: 0.75) {
            self.answerButtons.forEach { $0.alpha = 1 }
            
            if UserDefaultsManager.score >= 5 {
                self.helpButton.alpha = 1.0
            }
        }
        
        if let quiz0 = quiz.next() {
            
            let fullQuestion = quiz0.element
            
            UIView.animate(withDuration: 0.1) {
                
                self.correctAnswer = fullQuestion.correct
                self.questionLabel.text = fullQuestion.question.localized
                
                let answers = fullQuestion.answers
                
                for i in 0..<self.answerButtons.count {
                    self.answerButtons[i].setTitle(answers[i].localized, for: .normal)
                }
                
                if let index = self.set.index(of: fullQuestion) {
                    self.remainingQuestionsLabel.text = "\(index + 1)/\(self.set.count)"
                }
            }
        }
        else {
            endOfQuestionsAlert()
        }
    }
    
    private func isSetCompleted() -> Bool {
        
        let topicName = Topic.topics[currentTopicIndex].name
        if let topicQuiz = DataStore.shared.completedSets[topicName] {
            return topicQuiz[currentSetIndex] ?? false
        }
        
        return false
    }
    
    private func okActionDetailed() {
        
        if !isSetCompleted() {
            UserDefaultsManager.correctAnswers += correctAnswers
            UserDefaultsManager.incorrectAnswers += incorrectAnswers
            UserDefaultsManager.score += (correctAnswers * 20) - (incorrectAnswers * 10)
        }
        
        let topicName = Topic.topics[currentTopicIndex].name
        DataStore.shared.completedSets[topicName]?[currentSetIndex] = true
        guard DataStore.shared.save() else { print("Error saving settings"); return }
        
        if !isSetFromJSON {
            performSegue(withIdentifier: "unwindToQuizSelector", sender: self)
        } else {
            performSegue(withIdentifier: "unwindToMainMenu", sender: self)
        }
    }
    
    private func repeatActionDetailed() {
        repeatTimes += 1
        correctAnswers = 0
        incorrectAnswers = 0
        setUpQuiz()
        UserDefaultsManager.score = oldScore
        pickQuestion()
    }
    
    private func verify(answer: UInt8) {
        
        pausePreviousSounds()
        
        if answer == correctAnswer {
            correctAnswers += 1
            Audio.correct?.play()
        }
        else {
            incorrectAnswers += 1
            Audio.incorrect?.play()
        }
        
        UIView.animate(withDuration: 0.75) {
            self.answerButtons[Int(answer)].backgroundColor = (answer == self.correctAnswer) ? .darkGreen : .alternativeRed
        }
        
        FeedbackGenerator.notificationOcurredOf(type: (answer == correctAnswer) ? .success : .error)
        
        // Restore the answers buttons to their original color
        UIView.animate(withDuration: 0.75) {
            self.answerButtons[Int(answer)].backgroundColor = .themeStyle(dark: .orange, light: .defaultTintColor)
        }
        
        pickQuestion()
    }
    
    private func pausePreviousSounds() {
        
        if let incorrectSound = Audio.incorrect, incorrectSound.isPlaying {
            incorrectSound.pause()
            incorrectSound.currentTime = 0
        }
        
        if let correctSound = Audio.correct, correctSound.isPlaying {
            correctSound.pause()
            correctSound.currentTime = 0
        }
    }
    
    // Alerts
    
    private func endOfQuestionsAlert() {
        
        let helpScore = oldScore - UserDefaultsManager.score
        let score = (correctAnswers * 20) - (incorrectAnswers * 10) - helpScore
        
        let title = "Score: ".localized + "\(score) pts"
        let message = "Reponses correctes: ".localized + "\(correctAnswers)" + "/" + "\(set.count)"
        
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertViewController.addAction(title: "OK".localized, style: .default) { action in self.okActionDetailed() }
        
        if (correctAnswers < set.count) && (repeatTimes < 2) && !isSetCompleted() {
            
            let repeatText = "Repeter".localized + " (\(2 - self.repeatTimes))"
            alertViewController.addAction(title: repeatText, style: .cancel) { action in self.repeatActionDetailed() }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(75)) {
            self.present(alertViewController, animated: true)
        }
    }
    
    private func showOKAlertWith(title: String, message: String) {
        let alertViewController = UIAlertController.OKAlert(title: title, message: message)
        present(alertViewController, animated: true)
    }
    
    private func setUpQuiz() {
        set = Topic.topics[currentTopicIndex].content.quiz[currentSetIndex].shuffled()
        quiz = set.enumerated().makeIterator()
    }
}


