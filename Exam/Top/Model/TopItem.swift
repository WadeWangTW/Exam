//
//  TopItem.swift
//  Exam
//
//  Created by Wade Wang on 2020/11/5.
//

import Foundation

struct QueryTopList {
    var type: String
    var page: Int
    var subtype: String?
}

struct TopItem: Codable {
    let mal_id: Int
    let end_date: String?
    let start_date: String?
    let title: String?
    let rank: Int?
    let image_url: String?
    let type: String?
    let url: String?
    var favorite: Bool? 
}
