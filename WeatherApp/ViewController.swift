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
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
     override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))&appid=\(ACCESS_KEY)"
        let url = URL(string: urlString)
        
        var city: String?
        var temperature: String?
        var errorHasOccured = false
        
        let task = URLSession.shared.dataTask(with: url!) { [weak self] (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                
                if let _ = json["cod"] {
                    errorHasOccured = true
                }
                
                if let name = json["name"] as? String {
                    city = name
                    errorHasOccured = false
                }
                
                if let main = json["main"] {
                    let temp = main["temp"] as? Double
                    var tempC = temp! - 273.15
                    tempC.round()
                    temperature = "\(Int(tempC)) C"
                }
                
                DispatchQueue.main.async {
                    if errorHasOccured {
                        self?.cityLabel.text = "Error has occured!"
                        self?.temperatureLabel.isHidden = true
                    } else {
                        self?.cityLabel.text = city!
                        self?.temperatureLabel.text = temperature!
                        self?.temperatureLabel.isHidden = false
                    }
                }
            }
            catch let jsonError {
                print(jsonError)
            }
        }
        
        task.resume()
    }
}
