//
//  CoreDataStorage.swift
//  iswift-lil-software
//
//  Created by Anggi Fergian on 10/05/23.
//

import Foundation
import CoreData
import UIKit

class CoreDataStorage {
    static let shared: CoreDataStorage = CoreDataStorage()
    
    private init() {
        printCoreDataDBPath()
    }
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.viewContext
    }()
    
    // MARK: Add New
    func addReadingList(item: Article) {
        var newsData: NewsData
        
        let fetchRequest = NewsData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", item.url)

        if let data = try? context.fetch(fetchRequest).first {
            newsData = data
        } else {
            newsData = NewsData(context: context)
        }

        newsData.addedAt    = Date()
        newsData.author     = item.author
        newsData.url        = item.url
        newsData.source     = item.source
        newsData.title      = item.title
        newsData.imageUrl   = item.image
        newsData.dateNews   = item.date
        newsData.newsDescription = item.description

        NotificationCenter.default.post(name: .addReadingList, object: nil)

        try? context.save()
    }
    
    // MARK: Get All
    func getReadingList() -> [Article] {
        let fetchRequest = NewsData.fetchRequest()
        
        let data = (try? context.fetch(fetchRequest)) ?? []
        
        let sortedDatas = data.sorted { news0, news1 in
            if let date0 = news0.addedAt, let date1 = news1.addedAt {
                return date0 < date1
            }
            
            return false
        }
        
        return sortedDatas.compactMap { $0.dto }
    }
    
    // MARK: Delete One
    func deleteReadingList(url: String) {
        let fetchRequest = NewsData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", url)

        if let data = try? context.fetch(fetchRequest).first {
            context.delete(data)

            NotificationCenter.default.post(name: .deleteReadingList, object: nil)

            try? context.save()
        }
    }
    
    // MARK: Check IsAdded
    func isAddedToReadingList(url: String) -> Bool {
        let fetchRequest = NewsData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", url)
        
        return (try? context.fetch(fetchRequest).first) != nil
    }
    
    // MARK: Print Path
    func printCoreDataDBPath() {
        let path = FileManager
                .default
                .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                .last?
                .absoluteString
                .replacingOccurrences(of: "file://", with: "")
                .removingPercentEncoding
        
        print("Core Data DB Path :: \(path ?? "Not found")")
    }
}

// MARK: - NewsData
extension NewsData {
    var dto: Article {
        let article = Article(
            author  : self.author ?? "",
            url     : self.url ?? "",
            source  : self.source ?? "",
            title   : self.title ?? "",
            description: self.newsDescription ?? "",
            image   : self.imageUrl ?? "",
            date    : self.dateNews ?? ""
        )
        
        return article
    }
}
