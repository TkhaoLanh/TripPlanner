//
//  Service.swift
//  TripPlanner
//
//  Created by user248619 on 10/16/23.
//

import Foundation

class Service {
    static var shared = Service()
    private init() {}
    enum ServiceError: Error {
        case badURL}
       
    func getData(url: String, query: [String:String]?, completion: @escaping (Result<Data, Error>) -> Void) {
            
           
            var urlComponents = URLComponents(string: url)!
           
            if let query = query {
            urlComponents.queryItems =  query.map(
                { URLQueryItem(name: $0.key, value: $0.value) }
            )
        }
           
            guard let url = urlComponents.url else {
                completion(.failure(ServiceError.badURL))
                return
            }
           
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
           
            let session = URLSession.shared
           
            session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    completion(.success(data))
                }
            }.resume()
        }
    }





