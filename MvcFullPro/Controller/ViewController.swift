//
//  ViewController.swift
//  MvcFullPro
//
//  Created by Ghassan  albakuaa  on 10/4/20.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var movieTable: UITableView!
    
    var movies: [Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                self.movieTable.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("yhjkyukikuoui")
        self.movieTable.dataSource = self
        self.movieTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        NetworkManager.shared.fetchMovies { (result) in
            switch result {
            case .success(let movies):
                self.movies.append(contentsOf: movies)
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }


}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell" , for: indexPath) as? TableViewCell
        else {
            return UITableViewCell()
        }
        self.setImage(cell: cell, imagePath: movies[indexPath.row].posterImage)
    //    cell.movieImageView.image = UIImage(named: "dice1")
       cell.movieTitle.text = self.movies[indexPath.row].title
        return cell
    }
    
    func setImage(cell: TableViewCell, imagePath: String) {
          NetworkManager.shared.fetchImage(imagePath: imagePath) { (result) in
                switch result {
                case .success(let image):
                 DispatchQueue.main.async {
                       cell.movieImageView.image = image
                }
    
               case .failure(let error):
                   print(error.localizedDescription)
                  
               }
           }
   
        }
        
    }
    


