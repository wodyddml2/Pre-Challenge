//
//  MainViewController.swift
//  Pre_Challenge
//
//  Created by J on 2023/02/22.
//

import UIKit
import SnapKit

struct NasaInfo {
    var image: UIImage
    var progress: Float
}

final class MainViewController: UIViewController {
    
    private let mainView = MainView()
    
    private let nasaURLs: [URL] = [
        URL(string: "https://www.nasa.gov/sites/default/files/thumbnails/image/curiosity_selfie.jpg")!,
        URL(string: "https://www.nasa.gov/sites/default/files/styles/full_width_feature/public/thumbnails/image/iss060e033385large.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2201/OrionStarFree3_Harbison_5000.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2112/M3Leonard_Bartlett_3843.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/2112/LeonardMeteor_Poole_2250.jpg")!
    ]
    
    private var nasaArr: [NasaInfo?] = Array(repeating: nil, count: 5) {
        didSet {
            DispatchQueue.main.async {
                self.mainView.tableView.reloadData()
            }
        }
    }
    
    private var observation: NSKeyValueObservation!
    
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
    
    deinit {
        observation.invalidate()
        observation = nil
    }
}

extension MainViewController {
    private func requestImage(index: Int, completion: @escaping (UIImage) -> Void){
        var request = URLRequest(url: nasaURLs[index])
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                  let data = data, error == nil,
                  let image = UIImage(data: data)
            else {
                print("Download image fail")
                return
            }
            completion(image)
        }
//
        observation = task.progress.observe(\.fractionCompleted, options: [.new], changeHandler: { progress, change in

            self.nasaArr[index] = NasaInfo(image: UIImage(systemName: "photo")!, progress: Float(progress.fractionCompleted))

        })
        
        task.resume()
    }
    
    @objc
    private func allLoadButtonTapped() {
        nasaArr = Array(repeating: nil, count: 5)
        
        for i in 0..<nasaArr.count {
            requestImage(index: i) { [weak self] image in
                self?.nasaArr[i] = NasaInfo(image: image, progress: 1.0)
                
            }
        }
    }
    
    @objc
    private func loadButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        nasaArr[tag] = nil
        requestImage(index: tag) { [weak self] image in
            self?.nasaArr[tag] = NasaInfo(image: image, progress: 1.0)
            
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nasaArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        
        cell.loadButton.tag = indexPath.row
        cell.loadButton.addTarget(self, action: #selector(loadButtonTapped(_:)), for: .touchUpInside)
        cell.nasaImage.image = nasaArr[indexPath.row]?.image ?? UIImage(systemName: "photo")
        cell.progressBar.progress = nasaArr[indexPath.row]?.progress ?? 0.0
        
        return cell
    }
}

