//
//  TopListViewModel.swift
//  Exam
//
//  Created by Wade Wang on 2020/11/5.
//

import Foundation
import UIKit

class TopListViewModel: NSObject {
    struct QueryType {
        let title: String
        let content: [String]?
    }
    
    let types = [QueryType(title: "anime", content: ["none", "airing", "upcoming", "tv", "movie", "ova", "special", "bypopularity", "favorite"]), QueryType(title: "manga", content: ["none", "manga", "novels", "oneshots", "doujin", "manhwa", "manhua", "bypopularity", "favorite"]),
                 QueryType(title: "people", content: nil), QueryType(title: "characters", content: nil)]
    
    let topItems = Observable<[TopItem]>(value: [])
    var favorites: [TopItem]
    let isLoading = Observable<Bool>(value: false)
    var query = QueryTopList(type: "anime", page: 1, subtype: nil)
    var showError: ((Error) -> Void)? = nil
    
    override init() {
        if let favoriteItemData = UserDefaults.standard.data(forKey: UserDefaultKey.favoriteList), let items = try? JSONDecoder().decode([TopItem].self, from: favoriteItemData) {
            self.favorites = items
        }
        else {
            self.favorites = [TopItem]()
        }
    }
    
    func start() {
        fetchTopList()
        
    }
    
    func fetchTopList() {
        isLoading.value = true
        APIManager.share.fetchTopList(query: query) { (topItems) in
            self.isLoading.value = false
            if self.query.page == 1 {
                self.topItems.value.removeAll()
            }
            self.topItems.value.append(contentsOf: topItems)
            
            for item in self.favorites {
                if let index = self.topItems.value.firstIndex(where: {$0.mal_id == item.mal_id}) {
                    self.topItems.value[index] = item
                }
            }
            
            
            
        } failure: { (error) in
            self.isLoading.value = false
            self.showError?(error)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        query.page = 1
        query.subtype = nil
        if component == 0 {
            query.type = types[row].title
            pickerView.selectRow(0, inComponent: 1, animated: true)
        }
        else if row != 0, let content = types[pickerView.selectedRow(inComponent: 0)].content{
            query.subtype = content[row]
        }
        fetchTopList()
    }
    
    func loadMore() {
        query.page += 1
        fetchTopList()
    }
    
    func setFavoriteState(malId: Int) {
        guard let itemIndex = topItems.value.firstIndex(where: {$0.mal_id == malId}) else {
            return
        }
        
        var topItem = topItems.value[itemIndex]
        if let index = favorites.firstIndex(where: {$0.mal_id == malId}) {
            topItem.favorite = false
            favorites.remove(at: index)
        }
        else {
            topItem.favorite = true
            favorites.append(topItem)
        }
        
        topItems.value[itemIndex] = topItem

        
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.setValue(data, forKey: UserDefaultKey.favoriteList)
        }
    }
    
    func checkFavorites() {
        
        for index in 0..<topItems.value.count {
            topItems.value[index].favorite = false
        }
        
        if let favoriteItemData = UserDefaults.standard.data(forKey: UserDefaultKey.favoriteList), let items = try? JSONDecoder().decode([TopItem].self, from: favoriteItemData) {
            favorites = items
        }
        else {
            favorites = [TopItem]()
        }
        
        for item in self.favorites {
            if let index = self.topItems.value.firstIndex(where: {$0.mal_id == item.mal_id}) {
                self.topItems.value[index] = item
            }
        }
    }
}
