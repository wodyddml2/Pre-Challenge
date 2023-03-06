//
//  MainTableViewCell.swift
//  Pre_Challenge
//
//  Created by J on 2023/02/22.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    
    let nasaImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let progressBar: UIProgressView = {
        let view = UIProgressView()
        return view
    }()
    
    let loadButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 5
        view.backgroundColor = .blue
        view.setTitle("Load", for: .normal)
        view.setTitleColor(.white, for: .normal)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [nasaImage, progressBar, loadButton].forEach  { contentView.addSubview($0) }
    }
    
    private func setConstraints() {
        nasaImage.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        
        loadButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(80)
            make.centerY.equalToSuperview()
        }
        
        progressBar.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(nasaImage.snp.trailing).offset(5)
            make.trailing.equalTo(loadButton.snp.leading).offset(10)
        }
    }
}
