//
//  ReadingViewController.swift
//  iswift-lil-software
//
//  Created by Anggi Fergian on 10/05/23.
//

import UIKit
import SafariServices

class ReadingViewController: UIViewController {

    @IBOutlet weak var readingListTable: UITableView!
    
    var readingList: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readingListTable.register(UINib(nibName: "NewsViewCell", bundle: nil), forCellReuseIdentifier: "news_cell")

        readingListTable.dataSource = self
        readingListTable.delegate   = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(readingListAdded(_:)),
            name: .addReadingList,
            object: nil
        )
        
        loadReadingList()
    }
    
    @objc func readingListAdded(_ sender: Any) {
        loadReadingList()
        readingListTable.reloadData()
    }
    
    private func loadReadingList() {
        readingList = CoreDataStorage.shared.getReadingList()
    }

}

// MARK: - TableDataSource
extension ReadingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = readingListTable.dequeueReusableCell(withIdentifier: "news_cell", for: indexPath) as! NewsViewCell
        
        let item = readingList[indexPath.row]
        
        var newDateLabel = ""
        
        if let index = item.date.firstIndex(of: "T") {
            newDateLabel = String(item.date[..<index])
        } else {
            newDateLabel = item.date
        }
        
        cell.dateLbl.text           = "\(newDateLabel) • \(item.source)"
        cell.headingLbl.text        = item.title
        cell.bookmarkBtn.isHidden   = true

        if !item.image.isEmpty {
            cell.thumbImage.sd_setImage(with: URL(string: item.image))
        } else {
            cell.thumbImage.image = nil
        }
        
        return cell
    }
}

// MARK: - TableDelegate
extension ReadingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = readingList[indexPath.row]
        
        if let url = URL(string: article.url) {
            let controller = SFSafariViewController(url: url)
            present(controller, animated: true)
        }
        
        readingListTable.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
            let item = self.readingList.remove(at: indexPath.row )
            self.readingListTable.deleteRows(at: [indexPath], with: .automatic)
            
            CoreDataStorage.shared.deleteReadingList(url: item.url)
            
            completion(true)
        }
        
        if #available(iOS 13.0, *) {
            deleteAction.image = UIImage(systemName: "trash")
        }
        
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
