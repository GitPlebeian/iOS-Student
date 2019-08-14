//
//  PostController.swift
//  Post
//
//  Created by Jackson Tubbs on 8/12/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

class PostController {
    
    let baseURL = URL(string: "http://devmtn-posts.firebaseio.com/posts")
    var posts: [Post] = []
    
    
    // MARK: - Custom Funcitons
    
    func fetchPosts(completion: @escaping ()-> Void) {
        guard let baseURL = baseURL else {return}
        let builtURL = baseURL.appendingPathExtension("json")
        var request = URLRequest(url: builtURL)
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
            } catch let error {
                print("Error at \(#function) \(error) \(error.localizedDescription)")
                completion()
                return
            }
        }.resume()
    }
    
    func addNewPostWith(username: String, text: String, completion: @escaping () -> Void) {
        
        let post = Post(text: text, username: username)
  
        var postData: Data
        
        do {
            let encoder = JSONEncoder()
            postData = try encoder.encode(post)
        } catch let error {
            print("Error in side of \(#function) \(error) --- \(error.localizedDescription)")
            completion()
            return
        }
        
        guard let postEndpoint = baseURL else {completion(); return}

        let builtURL = postEndpoint.appendingPathExtension("json")
        var request = URLRequest(url: builtURL)
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error in side of \(#function) \(error) --- \(error.localizedDescription)")
                completion()
                return
            }
            guard let data = data else {completion();return}
            
            let unwrappedData = String(data: data, encoding: .utf8)
            
            print(unwrappedData ?? "NO DATA")
            self.fetchPosts {
                completion()
                return
            }
        }.resume()
    }
}
