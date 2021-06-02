//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import SwiftyJSON
import PKHUD

class ResultViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var stargazersLbl: UILabel!
    @IBOutlet weak var wachersLbl: UILabel!
    @IBOutlet weak var forksLbl: UILabel!
    @IBOutlet weak var issuesLbl: UILabel!
    
    var passedReport : JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        getImage()
    }
    
    func getImage(){
        let owner = passedReport["owner"]
        if let imgURL = owner["avatar_url"].string {
            HUD.show(.progress)
            URLSession.shared.dataTask(with: URL(string: imgURL)!) { (data, res, err) in
                guard let result = data else {return}
                HUD.hide()
                if let img = UIImage(data: result){
                        self.imgView.image = img
                }
            }.resume()
            
        }
    }
    
    func loadUI(){
        
        guard let language = passedReport["language"].string,
              let starCount = passedReport["stargazers_count"].number,
              let watch = passedReport["watchers_count"].number,
              let fork = passedReport["forks_count"].number,
              let issue = passedReport["open_issues_count"].number,
              let title = passedReport["full_name"].string
        else {return}
        
        languageLbl.text = "Written in \(language)"
        stargazersLbl.text = "\(starCount) stars"
        wachersLbl.text = "\(watch) watchers"
        forksLbl.text = "\(fork) forks"
        issuesLbl.text = "\(issue) open issues"
        titleLbl?.text = "\(title)"
        
    }
    
}
