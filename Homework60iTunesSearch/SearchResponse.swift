//
//  SearchResponse.swift
//  Homework60iTunesSearch
//
//  Created by 黃柏嘉 on 2022/1/25.
//

import Foundation

//自訂型別
struct SearchItem:Codable{
    var trackName:String
    var artistName:String
    var artworkUrl100:URL
    var trackViewUrl:URL
    var description:String
        
    //列舉所有資料，有不同的則輸入名字在rawValue
    enum CodingKeys:String,CodingKey{
        case trackName
        case artistName
        case artworkUrl100
        case trackViewUrl
        case description
    }
    
    //加入另一個enum列舉同一個資料的另一個名字
    enum AddKeys:String,CodingKey{
        case description = "longDescription"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.trackName = try container.decode(String.self, forKey: .trackName)
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.artworkUrl100 = try container.decode(URL.self, forKey: .artworkUrl100)
        self.trackViewUrl = try container.decode(URL.self, forKey: .trackViewUrl)
        
        
        if let description = try? container.decode(String.self, forKey: .description){
            self.description = description
        }else{
            let container = try decoder.container(keyedBy: AddKeys.self)
            self.description = (try? container.decode(String.self, forKey: .description)) ?? ""
        }
    }
}

//所有資料
struct SearchResponse:Codable{
    let results:[SearchItem]
}
