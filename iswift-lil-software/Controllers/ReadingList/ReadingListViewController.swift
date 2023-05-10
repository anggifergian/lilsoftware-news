//
//  ReadingListViewController.swift
//  iswift-lil-software
//
//  Created by Anggi Fergian on 10/05/23.
//

import UIKit

class ReadingListViewController: UIViewController {

    @IBOutlet weak var readingListTable: UITableView!
    
    var readingList: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        readingListTable.dataSource = self
        readingListTable.delegate = self
    }

}

// MARK: - UITableViewDataSource
extension ReadingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = readingListTable.dequeueReusableCell(withIdentifier: "news_cell", for: indexPath) as! NewsViewCell
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ReadingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        readingListTable.deselectRow(at: indexPath, animated: true)
    }
}
