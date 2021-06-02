//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import PKHUD
import SwiftyJSON
import Alamofire

class SearchListViewController: UITableViewController, UISearchBarDelegate{
    
    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    var report = [JSON]()
    
    var searchWord: String!
    var searchUrl: String!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        SearchBar.delegate = self
        tableView.rowHeight = 43.5
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchWord = searchBar.text else {return}
        self.searchWord = searchWord
        
        if searchWord.count != 0 {
            searchUrl = "https://api.github.com/search/repositories?q=\(searchWord)"
            guard let url = searchUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
                HUD.show(.progress)
                switch response.result {
                case .success(_):
                    let json = JSON(response.data as Any)
                    if let items = json["items"].array {
                        self.report = items
                    }else{
                        print("データがありません")
                    }
                    
                case .failure(let error):
                    print(error)
                }
                HUD.hide()
            }
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail"{
            if let dtl = segue.destination as? ResultViewController {
                dtl.passedReport = report[index]
            }else{
                print("segueの接続先が違います")
            }
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return report.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let rp = report[indexPath.row]
        cell.textLabel?.text = rp["full_name"].string
        cell.detailTextLabel?.text = rp["language"].string
        cell.tag = indexPath.row
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
        
    }
    
}
