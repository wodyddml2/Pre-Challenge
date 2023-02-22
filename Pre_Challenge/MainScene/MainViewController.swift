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
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }


}

