//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Egor on 30/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    //test data
    private let testData = [MessageCellModel(text: "Good bye!", isOutput: true),
                            MessageCellModel(text: "It’s morning in Tokyo", isOutput: true),
                            MessageCellModel(text: "What is the most popular meal in Japan?", isOutput: false),
                            MessageCellModel(text: "Do you like it?", isOutput: false),
                            MessageCellModel(text: "What is the most popular meal in Japan?", isOutput: false),
                            MessageCellModel(text: "I like it", isOutput: true),]
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
    }
}

extension ConversationViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        testData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = testData[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversatioinCell", for: indexPath) as? ConversationTableViewCell else {return UITableViewCell()}
        
        cell.configure(with: message)
        return cell
    }
}

extension ConversationViewController: UITableViewDelegate{
    //
}
