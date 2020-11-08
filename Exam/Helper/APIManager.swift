//
//  APIManager.swift
//  Exam
//
//  Created by Wade Wang on 2020/11/5.
//

import Alamofire

class APIManager {
    enum API {
        case topList(query: QueryTopList)
        
        static let serverDomain = "https://api.jikan.moe/v3"
        var url: URL? {
            switch self {
            case .topList(let query):
                var url = URL(string: API.serverDomain + "/top")
                url = url?.appendingPathComponent(query.type)
                url = url?.appendingPathComponent("\(query.page)")
                if let subType = query.subtype {
                    url = url?.appendingPathComponent(subType)
                }
                
                return url
            }
        }
        
    }
    
    static let share = APIManager()
    private init () {
        
    }
    
}

class Response: Decodable {
    let request_hash: String
}

//MARK Top
extension APIManager {
    func fetchTopList(query: QueryTopList, success: @escaping  ([TopItem]) -> (), failure: @escaping (Error) -> ()) {
        
        struct Response: Decodable {
            let request_hash: String
            let request_cached: Bool
            let request_cache_expiry: Int
            let top: [TopItem]
        }
        
        AF.request(API.topList(query: query).url!).responseData { (responseData) in
            switch responseData.result {
            case .success(let data):
                do {
                    let jsonObject = try JSONDecoder().decode(Response.self, from: data)
                    success(jsonObject.top)
                }
                catch {
                    failure(error)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
