//
//  CollectionDelegate.swift
//  UsedCarShop
//
//  Created by 김동준 on 2023/02/01.
//

import UIKit

final class DetailCarTableViewDataSource: NSObject {
    private var cars = [CarDTO]()
    private var carShop: CarShopDTO?
    func update(cars: [CarDTO]) {
        self.cars = cars
    }
    
    func update(carShop: CarShopDTO) {
        self.carShop = carShop
    }
}
extension DetailCarTableViewDataSource: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailCarShopHeaderView.id) as? DetailCarShopHeaderView else {
            return nil
        }
        headerView.configurate(with: carShop)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.carshopHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CarShopDetailCell.id) as? CarShopDetailCell else {
            return UITableViewCell()
        }
        let car = cars[indexPath.item]
        cell.configuration(with: car)
        return cell
    }
}
