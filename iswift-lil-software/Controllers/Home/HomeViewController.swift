//
//  HomeViewController.swift
//  iswift-lil-software
//
//  Created by Anggi Fergian on 05/05/23.
//

import UIKit
import SDWebImage
import SafariServices

class HomeViewController: UIViewController {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    weak var pageControl: UIPageControl!
    weak var refreshControl: UIRefreshControl!
    weak var topCollectionView: UICollectionView!
    
    var readingList: [Article] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTableView.register(UINib(nibName: "NewsViewCell", bundle: nil), forCellReuseIdentifier: "news_cell")
        
        newsTableView.dataSource = self
        newsTableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        newsTableView.refreshControl = refreshControl
        self.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.beginRefreshing()
        
        loadArticles()
    }
    
    @objc func handleRefresh() {
        print("Refreshing...")
        loadArticles()
    }
    
    func loadArticles() {
        ArticleService.shared.loadArticleList { [weak self] result in
            guard let strongSelf = self else { return }
            
            strongSelf.refreshControl.endRefreshing()
            
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return readingList.count > 0 ? 1 : 0
        }
        
        return readingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = newsTableView.dequeueReusableCell(withIdentifier: "top_news_cell", for: indexPath) as! TopNewsViewCell
            
            cell.headingLbl.text    = "News For You"
            cell.subtitleLbl.text   = "Top \(readingList.count) News of the day"
            cell.pageControl.numberOfPages = readingList.count
            
            self.pageControl        = cell.pageControl
            self.topCollectionView  = cell.topCollectionView
            
            cell.topCollectionView.dataSource   = self
            cell.topCollectionView.delegate     = self
            cell.topCollectionView.reloadData()
            
            cell.delegate = self
            
            return cell
        }
        
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

// MARK: - UITableDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        
        let article = readingList[indexPath.row]
        
        if let url = URL(string: article.url) {
            let controller = SFSafariViewController(url: url)
            present(controller, animated: true)
        }
        
        newsTableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UICollectionDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return readingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "top_news_collection_view", for: indexPath) as! TopNewsCollectionViewCell
        
        let item = readingList[indexPath.row]
        
        cell.topHeadingLbl.text = item.title

        var newDateLabel = ""
        
        if let index = item.date.firstIndex(of: "T") {
            newDateLabel = String(item.date[..<index])
        } else {
            newDateLabel = item.date
        }
        
        cell.topDateLbl.text = "\(newDateLabel) • \(item.source)"

        if !item.image.isEmpty {
            cell.topThumbImage.sd_setImage(with: URL(string: item.image))
        } else {
            cell.topThumbImage.image = nil
        }
        
        return cell
    }
}

// MARK: - UICollectionDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: 256)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView != self.newsTableView {
            let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
            pageControl?.currentPage = page
        }
    }
}

// MARK: - TopNewsViewCellDelegate
extension HomeViewController: TopNewsViewCellDelegate {
    func topNewsViewCellPageControlValueChanged(_ cell: TopNewsViewCell) {
        let pageIndex = cell.pageControl.currentPage
        
        topCollectionView.scrollToItem(
            at: IndexPath(item: pageIndex, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
    }
}
