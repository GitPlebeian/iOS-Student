//
//  PostController.swift
//  Post
//
//  Created by Jackson Tubbs on 8/12/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

class PostController {
    
    var baseURL = URL(string: "http://devmtn-posts.firebaseio.com/posts")
    var posts: [Post] = []
    
    func fetchPosts(completion: @escaping ()-> Void) {
        baseURL?.appendPathExtension("json")
        guard let baseURL = baseURL else {return}
        var request = URLRequest(url: baseURL)
        request.httpBody = nil
        request.httpMethod = "GET"
        print(baseURL)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print("Error getting posts \(error) \(error.localizedDescription)")
                completion()
                return
            }
            
            guard let data = data else {completion(); return}
            let decoder = JSONDecoder()
            do {
                let postsDictionary = try decoder.decode([String: Post].self, from: data)
                var posts = postsDictionary.compactMap({$0.value})
                posts.sort(by: {$0.timestamp > $1.timestamp})
                self.posts = posts
                completion()
                return
            } catch let error {
                print("Error at \(#function) \(error) \(error.localizedDescription)")
                completion()
                return
            }
        }.resume()
    }
}
