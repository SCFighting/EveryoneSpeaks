//
//  HomeCell.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/3/10.
//

import UIKit

class HomeCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(reservationLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nicknameLabel)
        selectionStyle = .none
        posterImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(15)
            make.top.equalTo(contentView.snp.top).offset(7.5)
            make.bottom.equalTo(contentView.snp.bottom).offset(-7.5).priority(.low)
            make.size.equalTo(CGSize(width: 133, height: 75))
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(posterImageView.snp.right).offset(10)
            make.top.equalTo(posterImageView)
            make.right.equalTo(contentView.snp.right).offset(-15)
        }
        reservationLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        avatarImageView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(posterImageView)
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.top.equalTo(reservationLabel.snp.bottom)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(5)
            make.right.equalTo(titleLabel)
            make.centerY.equalTo(avatarImageView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var posterImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#202020")
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    lazy var reservationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#888888")
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    lazy var avatarImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#888888")
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()

}
