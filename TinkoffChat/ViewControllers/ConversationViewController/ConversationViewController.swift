//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Egor on 30/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit
import Firebase

class ConversationViewController: UIViewController {
    private var messages = [Message]()
    var channelID: String = ""
    var myID: String = ""
    
    private let fbManager = FirebaseManager()
    
    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.register(ConversationTableViewCell.self, forCellReuseIdentifier: "ConversatioinCell")
        self.tableview.backgroundColor = UIColor(white: 0.9, alpha: 1)
        navigationItem.largeTitleDisplayMode = .never
        
        fbManager.fetchMessages(id: channelID) { [weak self] fetchedMessages in
            guard let slf = self else{return}
            slf.messages = fetchedMessages
            slf.tableview.reloadData()
        }
    }
}

extension ConversationViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let message = messages[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversatioinCell", for: indexPath) as? ConversationTableViewCell else {return UITableViewCell()}

        cell.configure(with: ConversationTableViewCell.ConfigureationModel.init(message: message, myID: myID))
        return cell
    }
}

extension ConversationViewController: UITableViewDelegate {
    //
}
