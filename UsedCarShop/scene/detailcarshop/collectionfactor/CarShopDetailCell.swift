//
//  CarShopCell.swift
//  UsedCarShop
//
//  Created by 김동준 on 2023/02/04.
//

import SnapKit
import Nuke

final class CarShopDetailCell: UITableViewCell {
    
    static let id: String = String(describing: CarShopDetailCell.self)
    
    private let carView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let line = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewAttribute()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        carView.image = nil
        titleLabel.text = nil
        subTitleLabel.text = nil
    }
}
extension CarShopDetailCell {
    private func viewAttribute() {
        addSubviews(carView, titleLabel, subTitleLabel, line)
        layout()
        line.backgroundColor = .systemGray4
    }
    
    private func layout() {
        carView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(carView.snp.trailing).offset(20)
            make.top.equalToSuperview().offset(35)
            make.trailing.equalToSuperview().inset(30)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(carView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(30)
        }
        
        line.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().inset(30)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
    }
    
    func configuration(with car: CarDTO) {
        titleLabel.text = car.name
        subTitleLabel.text = car.doodleDTODescription
        Nuke.loadImage(with: ImageRequest(url: URL(string: car.imageURL)!, priority: .high),
                       into: carView)
    }
}
