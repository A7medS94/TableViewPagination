//
//  MainVC.swift
//  TableViewPagination
//
//  Created by Ahmed Samir on 9/12/19.
//  Copyright © 2019 Ahmed Samir. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var prevBtnOL: UIBarButtonItem!
    @IBOutlet weak var nextBtnOL: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var postsObject: [Posts] = []//Changable
    var client: HTTPClient?
    let perPage = 5//Changable
    var totalPages = 1
    var currentPage = 1
    var startIndex = 0
    var isExtra = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        client = HTTPClient()
        client?.getPosts(from: URL(string: "https://jsonplaceholder.typicode.com/posts")!, success: { (posts) in
            self.postsObject = posts
            if self.postsObject.count % self.perPage == 0 {
                self.totalPages = self.postsObject.count / self.perPage
                self.isExtra = false
            }else{
                self.totalPages = (self.postsObject.count / self.perPage) + 1
                self.isExtra = true
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }, failure: { (error) in
            print(error)
        })
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.prevBtnOL.isEnabled = false
    }
    
    func tableViewAnimated(from subtype: CATransitionSubtype){
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = .push
        transition.subtype = subtype
        self.tableView.layer.add(transition, forKey: nil)
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        tableViewAnimated(from: .fromRight)
        if currentPage != totalPages {
            currentPage += 1
            tableView.reloadData()
        }else{
            print("Something Went Wrong!")
        }
        self.prevBtnOL.isEnabled = true
    }
    
    @IBAction func prevBtn(_ sender: Any) {
        tableViewAnimated(from: .fromLeft)
        if currentPage == totalPages{
            currentPage -= 1
            if isExtra{
                startIndex -= perPage + (postsObject.count % perPage)
                tableView.reloadData()
            }else{
                startIndex -= perPage * 2
                tableView.reloadData()
            }
        }else if currentPage < totalPages && currentPage != 1 {
            currentPage -= 1
            startIndex -= perPage * 2
            tableView.reloadData()
        }else {
            print("Something Went Wrong!")
        }
        if currentPage == 1 {
            self.prevBtnOL.isEnabled = false
        }
    }
}


extension MainVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if perPage < postsObject.count {
            if currentPage == totalPages{
                self.nextBtnOL.isEnabled = false
                return postsObject.count - startIndex
            }else{
                self.nextBtnOL.isEnabled = true
                return perPage
            }
        }else{
            self.nextBtnOL.isEnabled = false
            return postsObject.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        cell.titleLbl.text = postsObject[startIndex].title ?? "nil"
        cell.bodyLbl.text = postsObject[startIndex].body ?? "nil"
        startIndex += 1
        
        return cell
    }
}
