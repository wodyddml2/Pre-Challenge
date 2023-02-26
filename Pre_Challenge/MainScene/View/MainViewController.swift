//
//  MainViewController.swift
//  Pre_Challenge
//
//  Created by J on 2023/02/22.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    let mainView = MainView()
    
    let nasaURLs: [URL] = [
        URL(string: "https://www.nasa.gov/sites/default/files/thumbnails/image/curiosity_selfie.jpg")!,
        URL(string: "https://www.nasa.gov/sites/default/files/styles/full_width_feature/public/thumbnails/image/iss060e033385large.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2201/OrionStarFree3_Harbison_5000.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2112/M3Leonard_Bartlett_3843.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2112/LeonardMeteor_Poole_2250.jpg")!
    ]
    
    var nasaImages: [UIImage?] = Array(repeating: nil, count: 5) {
        didSet {
            DispatchQueue.main.async {
                self.mainView.tableView.reloadData()
            }
        }
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.allLoadButton.addTarget(self, action: #selector(allLoadButtonTapped), for: .touchUpInside)
    }
}

extension MainViewController {
    func requestImage(url: URL, completion: @escaping (UIImage) -> Void){
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                  let data = data, error == nil,
                  let image = UIImage(data: data)
            else {
                print("Download image fail")
                return
            }
            completion(image)
        }.resume()
    }
    
    @objc
    func allLoadButtonTapped() {
        nasaImages = Array(repeating: nil, count: 5)
        
        for i in 0..<nasaURLs.count {
            requestImage(url: nasaURLs[i]) { [weak self] image in
                self?.nasaImages[i] = image
            }
        }
    }
    
    @objc
    private func loadButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        nasaImages[tag] = nil
        requestImage(url: nasaURLs[tag]) { [weak self] image in
            self?.nasaImages[tag] = image
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nasaImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        cell.loadButton.tag = indexPath.row
        cell.loadButton.addTarget(self, action: #selector(loadButtonTapped(_:)), for: .touchUpInside)
        cell.nasaImage.image = nasaImages[indexPath.row] ?? UIImage(systemName: "photo")
        return cell
    }
}

