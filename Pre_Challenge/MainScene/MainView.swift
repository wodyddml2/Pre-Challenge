//
//  MainView.swift
//  Pre_Challenge
//
//  Created by J on 2023/02/22.
//

import UIKit
import SnapKit

class MainView: UIView {
    
    let tableView: UITableView = {
        let view = UITableView()
        return view
    }()
    
    let allLoadButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 5
        view.setTitle("Load All Images", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .blue
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [tableView, allLoadButton].forEach { self.addSubview($0) }
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(allLoadButton.snp.top).offset(10)
        }
        
        allLoadButton.snp.makeConstraints { make in
            make.bottom.trailing.leading.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
    }
}
