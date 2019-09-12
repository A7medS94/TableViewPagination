//
//  HTTPClient.swift
//  TableViewPagination
//
//  Created by Ahmed Samir on 9/12/19.
//  Copyright © 2019 Ahmed Samir. All rights reserved.
//

import Foundation
typealias success = (_ posts: [Posts])-> Void
typealias failure = (_ error: String)-> Void

class HTTPClient {
    
    func getPosts(from url: URL, success: @escaping success, failure: @escaping failure){
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do{
                let JSON = try JSONDecoder().decode([Posts].self, from: data!)
                success(JSON)
            }catch{
                failure(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
}
