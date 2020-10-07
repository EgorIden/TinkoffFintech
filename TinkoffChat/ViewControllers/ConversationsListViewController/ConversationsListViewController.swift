//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Egor on 28/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    //test data
    private let testData = [Section(name: "Online", dialogs: [ConversationCellModel(name: "User1", message: "Message1asasdasdadsadasdasdasdasdassdsasdassdad", date: Date(), isOnline: true, hasUnreadedMessages: true),
    ConversationCellModel(name: "User2", message: "", date:  Date(), isOnline: true, hasUnreadedMessages: false),
    ConversationCellModel(name: "User3", message: "", date:  .init(timeIntervalSince1970: 0), isOnline: true, hasUnreadedMessages: false),
    ConversationCellModel(name: "User4", message: "Message4", date:  .init(timeIntervalSince1970: 0), isOnline: true, hasUnreadedMessages: true),
    ConversationCellModel(name: "User5", message: "Message5", date:  .init(timeIntervalSince1970: 0), isOnline: true, hasUnreadedMessages: false),
    ConversationCellModel(name: "User6", message: "Message6", date:  Date(), isOnline: true, hasUnreadedMessages: false),
    ConversationCellModel(name: "User7", message: "", date:  .init(timeIntervalSince1970: 0), isOnline: true, hasUnreadedMessages: false),
    ConversationCellModel(name: "User8", message: "Message8", date:  Date(), isOnline: true, hasUnreadedMessages: false),
    ConversationCellModel(name: "User9", message: "Message9", date:  .init(timeIntervalSince1970: 0), isOnline: true, hasUnreadedMessages: false),
    ConversationCellModel(name: "User10", message: "Message10", date:  .init(timeIntervalSince1970: 0), isOnline: true, hasUnreadedMessages: true),
    ConversationCellModel(name: "User11", message: "", date:  .init(timeIntervalSince1970: 0), isOnline: true, hasUnreadedMessages: false)]),
                            Section(name: "History", dialogs: [ConversationCellModel(name: "User12", message: "Message12", date:  .init(timeIntervalSince1970: 0),
                                                                                     isOnline: false, hasUnreadedMessages: false),
    ConversationCellModel(name: "User13", message: "", date:  .init(timeIntervalSince1970: 0), isOnline: false, hasUnreadedMessages: false),
    ConversationCellModel(name: "User14", message: "", date:  .init(timeIntervalSince1970: 0), isOnline: false, hasUnreadedMessages: false),
    ConversationCellModel(name: "User15", message: "Message15", date:  .init(timeIntervalSince1970: 0), isOnline: false, hasUnreadedMessages: true),
    ConversationCellModel(name: "User16", message: "", date:  .init(timeIntervalSince1970: 0), isOnline: false, hasUnreadedMessages: false),
    ConversationCellModel(name: "User17", message: "Message17", date:  .init(timeIntervalSince1970: 0), isOnline: false, hasUnreadedMessages: false),
    ConversationCellModel(name: "User18", message: "", date:  .init(timeIntervalSince1970: 0), isOnline: false, hasUnreadedMessages: false),
    ConversationCellModel(name: "User19", message: "Message19", date:  Date(), isOnline: false, hasUnreadedMessages: false),
    ConversationCellModel(name: "User20", message: "Message20", date:  .init(timeIntervalSince1970: 0), isOnline: false, hasUnreadedMessages: true),
    ConversationCellModel(name: "User21", message: "Message21", date:  .init(timeIntervalSince1970: 0), isOnline: false, hasUnreadedMessages: true),
    ConversationCellModel(name: "User22", message: "Message22", date:  .init(timeIntervalSince1970: 0), isOnline: false, hasUnreadedMessages: false)])]
    
    
    @IBOutlet weak var tableView: UITableView!
    private let themeVC = ThemesViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setupBarButtons()
    }
    
    private func setupBarButtons(){
        
        let settings = UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal)
        let settingBarButton = UIBarButtonItem(image: settings, style: .plain , target: self, action: #selector(self.openSettings))
        navigationItem.leftBarButtonItem = settingBarButton
        
        let profile = UIImage(named: "profile_small")?.withRenderingMode(.alwaysOriginal)
        let profileBarButton = UIBarButtonItem(image: profile, style: .plain , target: self, action: #selector(self.openProfile))
        navigationItem.rightBarButtonItem = profileBarButton
    }
    
    @objc private func openProfile() {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Profile", bundle:nil)
        let profileVC = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        guard let profile = profileVC else {return}
        self.present(profile, animated: true, completion: nil)
    }
    
    @objc private func openSettings() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "ThemesViewController", bundle:nil)
        let themesVC = storyBoard.instantiateViewController(withIdentifier: "ThemesViewController") as? ThemesViewController
        
        guard let theme = themesVC else { return }
        theme.title = "Settings"
        theme.navigationItem.largeTitleDisplayMode = .never
        
        //делегат и замыкание
        
        theme.themeHandler = { [weak self] color in
            guard let selfVC = self else {return}
            selfVC.view.backgroundColor = color
        }
        
        //theme.delegate = self
        
        self.navigationController?.pushViewController(theme, animated: true)
    }
    
}

extension ConversationsListViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        testData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        testData[section].dialogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = testData[indexPath.section]
        let dialog = section.dialogs[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversatioinsCell", for: indexPath) as? ConversationsTableViewCell else {return UITableViewCell()}
        
        cell.configure(with: dialog)
        return cell
    }
}

extension ConversationsListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return testData[section].name
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        
        let titleVC = testData[indexPath.section].dialogs[indexPath.row].name
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Conversation", bundle:nil)
        let conversationVC = storyBoard.instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController
        
        guard let destinationVC = conversationVC else { return }
        destinationVC.title = titleVC
        destinationVC.navigationItem.largeTitleDisplayMode = .never
        
        self.themeVC.themeHandler = { color in
            destinationVC.view.backgroundColor = color
        }
        
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension ConversationsListViewController: ThemePickerDelegate{
    func chosenTheme(_ bgColor: UIColor) {
        self.view.backgroundColor = bgColor
    }
}
