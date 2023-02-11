//
//  DetailCarShopHeaderView.swift
//  UsedCarShop
//
//  Created by 김동준 on 2023/02/09.
//

import SnapKit

final class DetailCarShopHeaderView: UITableViewHeaderFooterView {
    
    static let id: String = String(describing: DetailCarShopHeaderView.self)
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .black
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()
    
    private let callButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "phone"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .black
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        viewAttribute()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subTitleLabel.text = nil
        subTitleLabel.text = nil
    }
}
extension DetailCarShopHeaderView {
    func configurate(with carShop: CarShopDTO?) {
        titleLabel.text = carShop?.name
        subTitleLabel.text = carShop?.alias
    }
    
    private func viewAttribute() {
        addSubviews(titleLabel, subTitleLabel, callButton)
        layout()
    }
    
    private func layout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        
        callButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(30)
        }
    }
}
