//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Egor on 30/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ConversationViewController: UIViewController {
    // UI
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.separatorStyle = .none
        table.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return table
    }()
    private let messageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let textView: UITextField = {
        let text = UITextField()
        text.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        text.textColor = UIColor.black
        text.backgroundColor = UIColor(white: 0.94, alpha: 1)
        text.layer.cornerRadius = 8
        return text
    }()
    private let sendButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "send"), for: .normal)
        btn.addTarget(self, action: #selector(sendBtnTapped),
                      for: UIControl.Event.touchUpInside)
        return btn
    }()
    var channelId: String = ""
    var myId: String = ""
    var model: IConversationModel?
    var presentationAssembly: IPresentationAssembly?
    private var containerBottomConstraint: NSLayoutConstraint?
    private var containerHeightConstraint: NSLayoutConstraint?
    private lazy var fetchedResultsController: NSFetchedResultsController<DBMessage>? = {
        let fetchRequest: NSFetchRequest<DBMessage> = DBMessage.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "channel.identifier = %@", channelId)
        fetchRequest.predicate = predicate
        fetchRequest.fetchBatchSize = 20
        guard let context = model?.getContext() else { return NSFetchedResultsController() }
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: "messages")
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerBottomConstraint = NSLayoutConstraint(item: messageContainer,
            attribute: .bottom, relatedBy: .equal,
            toItem: view, attribute: .bottom,
            multiplier: 1, constant: 0)
        self.navigationItem.largeTitleDisplayMode = .never
        self.setupContainerConstraints()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: "ConversatioinCell")
        self.fetchMessages(channelId: channelId)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func fetchMessages(channelId: String) {
        print(channelId)
        do {
            try fetchedResultsController?.performFetch()
            tableView.reloadData()
        } catch {
            print("fetching messages error -> \(error.localizedDescription)")
        }
        model?.fetchMessages(channelId: channelId)
        print("fetched messages -> \(fetchedResultsController?.fetchedObjects?.count)")
    }
    // UI settings
    private func setupContainerConstraints() {
        let constr = [
            messageContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            messageContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            messageContainer.heightAnchor.constraint(equalToConstant: 90),
            containerBottomConstraint!,
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: messageContainer.topAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ]
        messageContainer.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(messageContainer)
        self.view.addSubview(tableView)
        self.view.addConstraints(constr)
        setupMessgeInputConstraints()
    }
    func setupMessgeInputConstraints() {
        let constr = [
            textView.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: messageContainer.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            textView.bottomAnchor.constraint(equalTo: sendButton.bottomAnchor, constant: 0),
            sendButton.topAnchor.constraint(equalTo: textView.topAnchor, constant: 0),
            sendButton.trailingAnchor.constraint(equalTo: messageContainer.trailingAnchor, constant: -8),
            sendButton.heightAnchor.constraint(equalToConstant: 56),
            sendButton.widthAnchor.constraint(equalToConstant: 56)
        ]
        textView.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        messageContainer.addSubview(textView)
        messageContainer.addSubview(sendButton)
        messageContainer.addConstraints(constr)
    }
    @objc func sendBtnTapped() {
        guard let message = textView.text else {return}
        if message != ""{
            model?.sendMessage(senderId: myId, channelId: channelId, message: message)
            textView.text = ""
        } else {
            print("insert text")
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
            as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            self.containerBottomConstraint!.constant = isKeyboardShowing ? -keyboardHeight : 0
            UIView.animate(withDuration: 0, delay: 0,
                           options: UIView.AnimationOptions.curveEaseOut,
                           animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

extension ConversationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController?.sections else { return 0}
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let message = fetchedResultsController?.object(at: indexPath) else {return UITableViewCell()}

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversatioinCell", for: indexPath) as? ConversationTableViewCell else {return UITableViewCell()}

        cell.configure(with: ConversationTableViewCell.ConfigureationModel.init(message: message, myID: myId))
        return cell
    }
}

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
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
            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
