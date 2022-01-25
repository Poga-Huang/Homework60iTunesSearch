//
//  SearchItemListViewController.swift
//  Homework60iTunesSearch
//
//  Created by 黃柏嘉 on 2022/1/25.
//

import UIKit
import SafariServices

private let reusableIdentifier = "itemCell"

class SearchItemListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    @IBOutlet weak var mediaTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var countrySegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchItemBar: UISearchBar!
    @IBOutlet weak var itemListTableView: UITableView!
    @IBOutlet weak var searchResultsCountLabel: UILabel!
    
   var items = [SearchItem]()
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    //function
    
    //抓資料
    func fetchSearchItems(){
        searchResultsCountLabel.text = "搜尋中..."
        items = []
        guard let searchTerm = searchItemBar.text else {return}
        let mediaType = MediaType.allCases[mediaTypeSegmentedControl.selectedSegmentIndex].rawValue
        let country = Country.allCases[countrySegmentedControl.selectedSegmentIndex].rawValue
        let query = [
            "term":searchTerm,
            "media":mediaType,
            "country":country
        ]
        SearchController.shared.fetchItems(matching: query) { result in
            switch result{
            case .success(let searchResponse):
                DispatchQueue.main.async {
                    self.items = searchResponse
                    self.searchResultsCountLabel.text = "搜尋到\(self.items.count)個結果"
                    self.itemListTableView.reloadData()
                }
            case .failure(let error):
                self.displayError(error, title: "資料抓取失敗")
            }
        }
    }
    
    //配置Cell
    func configure(cell:ItemTableViewCell,forRowAt indexPath:IndexPath){
        let itemsResults = items[indexPath.row]
        cell.nameLabel.text = itemsResults.trackName
        cell.artistLabel.text = itemsResults.artistName
        if itemsResults.description != ""{
            cell.descriptionTextView.isHidden = false
            cell.descriptionTextView.text = itemsResults.description
        }else{
            cell.descriptionTextView.isHidden = true
        }
        SearchController.shared.fetchImage(from: itemsResults.artworkUrl100) { result in
            switch result{
            case .success(let image):
                DispatchQueue.main.async {
                    if indexPath == self.itemListTableView.indexPath(for: cell){
                        cell.coverImageView.image = image
                    }
                }
            case .failure(let error):
                self.displayError(error, title: "\(itemsResults.trackName)圖片抓取失敗")
                DispatchQueue.main.async {
                    cell.coverImageView.image = UIImage(systemName: "photo")
                }
            }
        }
    }
    func displayError(_ error:Error,title:String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Refresh", style: .default, handler: { _ in
                self.fetchSearchItems()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    //segmentedControl Action
    @IBAction func selectMediaType(_ sender: UISegmentedControl) {
        fetchSearchItems()
    }
    @IBAction func selectCountry(_ sender: UISegmentedControl) {
        fetchSearchItems()
    }
    
    //TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as? ItemTableViewCell else{return UITableViewCell()}
        if items.isEmpty == false{
            configure(cell: cell, forRowAt: indexPath)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trackViewUrl = items[indexPath.row].trackViewUrl
        let controller = SFSafariViewController(url: trackViewUrl)
        present(controller, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}


extension SearchItemListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchSearchItems()
        searchItemBar.resignFirstResponder()
    }
    
}

