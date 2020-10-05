//
//  NewtworkManager.swift
//  MvcFullPro
//
//  Created by Ghassan  albakuaa  on 10/4/20.
//

import UIKit

struct API_URLs {
    static let nowPlayingURL = "https://api.themoviedb.org/3/movie/popular?api_key=705f7bed4894d3adc718c699a8ca9a4f&page="
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500/"
}

enum NetworkError: Error {
    case badData
    case badImage
    case decodeFailure
    case badURL
    case err
}
typealias MovieHandler = (Result<[Movie], NetworkError>) -> ()
typealias ImageHandler = (Result<UIImage?, NetworkError>) -> ()

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    let session: URLSession
    let decoder: JSONDecoder
    var currentPage: PageResult?
   private init(session: URLSession = URLSession.shared , decoder:JSONDecoder = JSONDecoder()) {
            self.session = session
            self.decoder = decoder
        }
    }

extension NetworkManager {
   // func fetchMovies(completion: @escaping (Result<Movie , Error>)) -> (){
    func fetchMovies(completion: @escaping MovieHandler) -> (){
        guard  let url = URL(string: API_URLs.nowPlayingURL) else {
            completion(.failure(.badURL))
            return
        }
        self.session.dataTask(with: url) {(data , response , error) in
            if let _ = error{
                completion(.failure(.err))
            }
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            do{
                let page = try self.decoder.decode(PageResult.self, from: data)
                self.currentPage = page
                completion(.success(page.results))
            }catch {
                completion(.failure(.decodeFailure))
            }
        }
    }

    
    func fetchImage(imagePath: String, completion: @escaping ImageHandler) {
        
        let fullPath = API_URLs.imageBaseURL + imagePath
        guard let url = URL(string: fullPath) else {
            completion(.failure(.badURL))
            return
        }
        
        self.session.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(.failure(.err))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(.badImage))
                return
            }
            
            completion(.success(image))
            return
        }.resume()
        
    }
    
}



