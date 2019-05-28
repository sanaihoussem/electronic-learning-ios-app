
import UIKit

class SettingsTableViewController: UITableViewController {
    
    private enum cellLabelsForSection0: String {
        
        case backgroundMusic = "Background Music"
        
        static let labels: [cellLabelsForSection0] = [.backgroundMusic]
        static let count = labels.count
    }
    
    let backgroundMusicSwitch = UISwitch()
    let hapticFeedbackSwitch = UISwitch()
    let parallaxEffectSwitch = UISwitch()
    let darkThemeSwitch = UISwitch()
    
    var switches: [UISwitch] {
        return [backgroundMusicSwitch, hapticFeedbackSwitch, parallaxEffectSwitch, darkThemeSwitch]
    }
    
    private enum cellLabelsForSection1: String {
        
        case resetProgress = "Réinitialiser progres"
        
        static let labels: [cellLabelsForSection1] = [.resetProgress]
        static let count = labels.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? cellLabelsForSection0.count : cellLabelsForSection1.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.resetProgressAlert(indexPath: indexPath)
                FeedbackGenerator.notificationOcurredOf(type: .warning)
            default: break
            }
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        cell.textLabel?.font = .preferredFont(forTextStyle: .body)
        cell.accessoryView = nil
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: cell.textLabel?.text = cellLabelsForSection1.resetProgress.rawValue.localized
            default: break
            }
        default: break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        guard section == 0 else { return nil }
        
        var completedSets = UInt()
        
        for topicQuiz in DataStore.shared.completedSets {
            for setQuiz in topicQuiz.value where setQuiz.value == true {
                completedSets += 1
            }
        }
        
        let correctAnswers = UserDefaultsManager.correctAnswers
        let incorrectAnswers = UserDefaultsManager.incorrectAnswers
        let numberOfAnswers = Float(incorrectAnswers + correctAnswers)
        let correctAnswersPercent = (numberOfAnswers > 0) ? Int(round((Float(correctAnswers) / numberOfAnswers) * 100.0)) : 0
        
        return "\n\("Statistiques".localized): \n\n" +
            "\("Niveaux terminés".localized): \(completedSets)\n" +
            "\("Réponses correctes".localized): \(correctAnswers)\n" +
            "\("Réponses incorrectes".localized): \(incorrectAnswers)\n" +
            "\("Ratio".localized): \(correctAnswersPercent)%\n\n"
    }
    
    // UITableView delegate
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        let cellColor: UIColor = .themeStyle(dark: .darkGray, light: .highlighedGray)
        let cell = tableView.cellForRow(at: indexPath)
        let view = UIView()
        
        UIView.animate(withDuration: 0.15) {
            cell?.backgroundColor = cellColor
            view.backgroundColor = cellColor
            cell?.selectedBackgroundView = view
        }
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.15) {
            cell?.backgroundColor = .themeStyle(dark: .veryDarkGray, light: .white)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as? UITableViewHeaderFooterView
        footer?.textLabel?.textColor = .themeStyle(dark: .lightGray, light: .gray)
        footer?.contentView.backgroundColor = .themeStyle(dark: .veryVeryDarkGray, light: .groupTableViewBackground)
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return tableView.cellForRow(at: indexPath)?.accessoryView == nil
    }
    

    


    private func resetProgressStatistics() {
        
        DataStore.shared.completedSets = [:]
        Topic.loadSets()
        guard DataStore.shared.save() else { print("Error saving settings"); return }
        
        UserDefaultsManager.correctAnswers = 0
        UserDefaultsManager.incorrectAnswers = 0
        UserDefaultsManager.score = 0
        
        self.tableView.reloadData()
    }
    
    private func resetProgressOptions() {
        
        self.resetProgressStatistics()
        
        if !UserDefaultsManager.parallaxEffectSwitchIsOn {
            UserDefaultsManager.parallaxEffectSwitchIsOn = true
        }
        
        UserDefaultsManager.backgroundMusicSwitchIsOn = true
        UserDefaultsManager.darkThemeSwitchIsOn = false
        UserDefaultsManager.hapticFeedbackSwitchIsOn = true
        
        
        let reduceMotion = UIAccessibilityIsReduceMotionEnabled()
        parallaxEffectSwitch.setOn(!reduceMotion, animated: true)
        parallaxEffectSwitch.isEnabled = !reduceMotion
        
        darkThemeSwitch.setOn(false, animated: true)
        backgroundMusicSwitch.setOn(true, animated: true)
        
        if #available(iOS 10.0, *) {
            hapticFeedbackSwitch.setOn(true, animated: true)
        } else {
            hapticFeedbackSwitch.setOn(false, animated: false)
            hapticFeedbackSwitch.isEnabled = false
            UserDefaultsManager.hapticFeedbackSwitchIsOn = false
        }
        
        
    }
    
   
    
    private func resetProgressAlert(indexPath: IndexPath) {
        let alertViewController = UIAlertController(title: nil, message: nil,
                                                    preferredStyle: .alert)
        
        alertViewController.modalPresentationStyle = .popover
        
        
        alertViewController.addAction(title: "Réinitialiser".localized, style: .default) { action in
            self.resetProgressStatistics()
        }
        alertViewController.addAction(title: "Cancel".localized, style: .cancel)
        self.present(alertViewController, animated: true)
    }
}

