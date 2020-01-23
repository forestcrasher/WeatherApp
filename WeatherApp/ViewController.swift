//
//  ViewController.swift
//  WeatherApp
//
//  Created by Anton Pryakhin on 23.01.2020.
//

import UIKit

let ACCESS_KEY = "db681f19d78408bc2a4236761f47920e"

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(searchBar.text!)&appid=\(ACCESS_KEY)"
        
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                
                if let name = json["name"] as? String {
                    print(name);
                }
                
                if let main = json["main"] {
                    let temp = main["temp"] as? Double
                    var tempC = temp! - 273.15
                    tempC.round()
                    print(Int(tempC))
                }
            }
            catch let jsonError {
                print(jsonError)
            }
        }
        
        task.resume()
    }
}
