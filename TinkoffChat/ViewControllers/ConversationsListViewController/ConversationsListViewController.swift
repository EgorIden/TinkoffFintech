//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Egor on 28/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit
import Firebase

class ConversationsListViewController: UIViewController {
    private var channels = [Channel]()
    private let fbManager = FirebaseManager()

    @IBOutlet weak var tableView: UITableView!
    private let themeVC = ThemesViewController()
    private let myID = UIDevice.current.identifierForVendor?.uuidString ?? "1111222333"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setupBarButtons()
        
        fbManager.fetchChannels { [weak self] channels in
            self?.channels = channels
            self?.tableView.reloadData()
        }
        print(myID)
    }
    private func setupBarButtons() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let settings = UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal)
        let settingBarButton = UIBarButtonItem(image: settings, style: .plain, target: self, action: #selector(self.openSettings))
        navigationItem.leftBarButtonItem = settingBarButton

        let channel = UIImage(named: "add")?.withRenderingMode(.alwaysOriginal)
        let channelBtn = UIBarButtonItem(image: channel, style: .plain, target: self, action: #selector(self.addChannel))
        
        let profile = UIImage(named: "profile_small")?.withRenderingMode(.alwaysOriginal)
        let profileBarButton = UIBarButtonItem(image: profile, style: .plain, target: self, action: #selector(self.openProfile))
        navigationItem.rightBarButtonItems = [profileBarButton,channelBtn]
    }

    @objc private func openProfile() {

        let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        guard let profile = profileVC else {return}

        let navVC = UINavigationController(rootViewController: profile)
        navVC.navigationBar.backgroundColor = UIColor(white: 0.97, alpha: 1)
        navVC.navigationBar.prefersLargeTitles = true

        self.present(navVC, animated: true, completion: nil)
    }
    
    @objc private func openSettings() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "ThemesViewController", bundle: nil)
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
    
    @objc private func addChannel() {
        
        let alert = UIAlertController(title: "Создать новый канал", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Название канала"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
            guard let channelName = alert.textFields?[0].text else {return}
            if channelName == "" {return}
            
            let newChannel = Channel(identifier: self.myID, name: channelName, lastMessage: "", lastActivity: Timestamp().dateValue())
            self.fbManager.addChannel(channel: newChannel)
            
        }))
        self.present(alert, animated: true)
        
    }

}

extension ConversationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.channels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let channel = self.channels[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversatioinsCell", for: indexPath) as? ConversationsTableViewCell else {return UITableViewCell()}

        cell.configure(with: ConversationsTableViewCell.ConfigureationModel.init(channel: channel))
        return cell
    }
}

extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let backButton = UIBarButtonItem()
        backButton.title = ""
        
        let titleVC = self.channels[indexPath.row].name
        let channelID = self.channels[indexPath.row].identifier
        print(channelID)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Conversation", bundle: nil)
        let destinationVC = storyBoard.instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController

        guard let conversationVC = destinationVC else { return }
        conversationVC.title = titleVC
        conversationVC.channelID = channelID
        conversationVC.myID = myID

        self.themeVC.themeHandler = { color in
            conversationVC.view.backgroundColor = color
        }

        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(conversationVC, animated: true)
    }
}

extension ConversationsListViewController: ThemePickerDelegate {
    func chosenTheme(_ bgColor: UIColor) {
        self.view.backgroundColor = bgColor
    }
}
