import UIKit

class TopicsViewController: UITableViewController {
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Topics".localized
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadCurrentTheme), name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCurrentTheme()
    }
    
    @available(iOS, deprecated: 9.0)
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Topic.topics.count
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "setCell")
        cell?.textLabel?.text = Topic.topics[indexPath.row].name.localized
        
        // Load theme
        cell?.textLabel?.font = .preferredFont(forTextStyle: .body)
        cell?.textLabel?.textColor = .themeStyle(dark: .white, light: .black)
        cell?.backgroundColor = .themeStyle(dark: .veryDarkGray, light: .white)
        cell?.tintColor = .themeStyle(dark: .orange, light: .defaultTintColor)
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "selectTopic", sender: indexPath.row)
    }
    
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
    
    // MARK: UIStoryboardSegue Handling
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let topicIndex = sender as? Int, segue.identifier == "selectTopic" {
            let controller = segue.destination as? QuizzesViewController
            controller?.currentTopicIndex = topicIndex
        }
    }
    
    // MARK: Convenience
    
    @IBAction internal func loadCurrentTheme() {
        tableView.backgroundColor = .themeStyle(dark: .veryVeryDarkGray, light: .groupTableViewBackground)
        tableView.separatorColor = .themeStyle(dark: .veryVeryDarkGray, light: .defaultSeparatorColor)
        tableView.reloadData()
    }
}

