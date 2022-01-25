//
//  SearchController.swift
//  Homework60iTunesSearch
//
//  Created by 黃柏嘉 on 2022/1/25.
//

import Foundation
import UIKit

class SearchController{
    
    static let shared = SearchController()
   
    
    func fetchItems(matching query:[String:String],completion:@escaping (Result<[SearchItem],Error>)->()){
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search")!
        urlComponents.queryItems = query.map{URLQueryItem(name: $0.key, value: $0.value)}
        URLSession.shared.dataTask(with: urlComponents.url!) {(data,reponse,error) in
            if let data = data {
                do{
                    let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                    completion(.success(searchResponse.results))
                }catch{
                    completion(.failure(error))
                }
            }else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchImage(from url:URL,completion:@escaping(Result<UIImage,Error>)->()){
        URLSession.shared.dataTask(with: url) { (data,response,error) in
            if let data = data,let image = UIImage(data: data) {
                completion(.success(image))
            }else if let error = error{
                completion(.failure(error))
            }
        }.resume()
    }
    
    
}
