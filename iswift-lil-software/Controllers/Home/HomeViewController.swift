//
//  HomeViewController.swift
//  iswift-lil-software
//
//  Created by Anggi Fergian on 05/05/23.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    var readingList: [Article] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTableView.register(UINib(nibName: "NewsViewCell", bundle: nil), forCellReuseIdentifier: "news_cell")
        
        newsTableView.dataSource = self
        newsTableView.delegate = self
        
        loadArticles()
    }
    
    func loadArticles() {
        ArticleService.shared.loadArticleList { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let data):
                strongSelf.readingList = data
                strongSelf.newsTableView.reloadData()
            case .failure(let err):
                print("Error...\(err.localizedDescription)")
            }
        }
    }
}

// MARK: - UITableDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "news_cell", for: indexPath) as! NewsViewCell
        
        let item = readingList[indexPath.row]
        
        cell.headingLbl.text = item.title

        var newDateLabel = ""
        
        if let index = item.date.firstIndex(of: "T") {
            newDateLabel = String(item.date[..<index])
        } else {
            newDateLabel = item.date
        }
        
        cell.dateLbl.text = "\(newDateLabel) • \(item.source)"

        if !item.image.isEmpty {
            cell.thumbImage.sd_setImage(with: URL(string: item.image))
        } else {
            cell.thumbImage.image = nil
        }
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newsTableView.deselectRow(at: indexPath, animated: true)
    }
}
