//
//  FavoriteViewModel.swift
//  Exam
//
//  Created by Wade Wang on 2020/11/8.
//

import UIKit

class FavoriteViewModel: NSObject {
    let favorites = Observable<[TopItem]>(value: [])
    
    func start() {
        
        if let data = UserDefaults.standard.data(forKey: UserDefaultKey.favoriteList),
           let items = try? JSONDecoder().decode([TopItem].self, from: data) {
            favorites.value.append(contentsOf: items)
        }
    }
    
    func unfavoriteMalId(malId: Int) {
        if let index = favorites.value.firstIndex(where: {$0.mal_id == malId}) {
            favorites.value.remove(at: index)
        }
        
        if let data = try? JSONEncoder().encode(favorites.value) {
            UserDefaults.standard.setValue(data, forKey: UserDefaultKey.favoriteList)
        }

    }
}
