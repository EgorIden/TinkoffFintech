//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Egor on 28/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ConversationsListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
var model: IConversationsModel?
    var presentationAssembly: IPresentationAssembly?
    private let themeVC = ThemesViewController()
    private let myId = UIDevice.current.identifierForVendor?.uuidString ?? "1111222333"
    private var emblem: EmblemAnimation?

    private lazy var fetchedResultsController: NSFetchedResultsController<DBChannel> = {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        let sortDescriptors = [NSSortDescriptor(key: "name", ascending: true),
                           NSSortDescriptor(key: "lastActivity", ascending: true)]
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.fetchBatchSize = 20
        guard let context = model?.getContext() else { return NSFetchedResultsController() }
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil, cacheName: "channelsList")
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setupBarButtons()
        self.fetchChannels()
        self.addAnimatioin()
    }
    private func addAnimatioin() {
        self.emblem = EmblemAnimation(view: self.view)
    }
    private func fetchChannels() {
        self.model?.fetchChannels()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("fetching channels error -> \(error.localizedDescription)")
        }
        print("fetched objects -> \(fetchedResultsController.fetchedObjects?.count)")
    }
    // MARK: Setup UI
    private func setupBarButtons() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let settings = UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal)
        let settingBarButton = UIBarButtonItem(image: settings, style: .plain,
                                               target: self, action: #selector(self.openSettings))
        navigationItem.leftBarButtonItem = settingBarButton

        let channel = UIImage(named: "add")?.withRenderingMode(.alwaysOriginal)
        let channelBtn = UIBarButtonItem(image: channel, style: .plain,
                                         target: self, action: #selector(self.addChannel))
        let profile = UIImage(named: "profile_small")?.withRenderingMode(.alwaysOriginal)
        let profileBarButton = UIBarButtonItem(image: profile, style: .plain,
                                               target: self, action: #selector(self.openProfile))
        navigationItem.rightBarButtonItems = [profileBarButton, channelBtn]
    }
    @objc private func openProfile() {
        guard let profileVC = presentationAssembly?.profileController() else { return }
        let navVC = UINavigationController(rootViewController: profileVC)
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
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            guard let channelName = alert.textFields?[0].text else {return}
            if channelName == "" {return}
            let newChannel = Channel(identifier: self.myId,
                                     name: channelName,
                                     lastMessage: "",
                                     lastActivity: Timestamp().dateValue())
            self.model?.addChannel(channel: newChannel)
        }))
        self.present(alert, animated: true)
    }
}

extension ConversationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else { return 0}
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let channel = fetchedResultsController.object(at: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversatioinsCell", for: indexPath) as? ConversationsTableViewCell else {return UITableViewCell()}

        cell.configure(with: ConversationsTableViewCell.ConfigureationModel.init(channel: channel))
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let channel = fetchedResultsController.object(at: indexPath)
            model?.deleteChannel(identifier: channel.identifier)
        }
    }
}
extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        let channel = fetchedResultsController.object(at: indexPath)
        let titleVC = channel.name
        let channelId = channel.identifier
        guard let conversationVC = presentationAssembly?.сonversationViewController() else { return }
        conversationVC.title = titleVC
        conversationVC.channelId = channelId
        conversationVC.myId = myId

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
extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {

        let indexPath = indexPath ?? IndexPath()
        let newIndexPath = newIndexPath ?? IndexPath()

        switch type {
        case .insert:
            self.tableView?.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            self.tableView?.deleteRows(at: [indexPath], with: .automatic)
            self.tableView?.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            self.tableView?.reloadRows(at: [indexPath], with: .automatic)
        case .delete:
            self.tableView?.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }
}
