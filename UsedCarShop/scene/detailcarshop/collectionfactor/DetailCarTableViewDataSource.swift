//
//  CollectionDelegate.swift
//  UsedCarShop
//
//  Created by 김동준 on 2023/02/01.
//

import UIKit

final class DetailCarTableViewDataSource: NSObject {
    private var cars = [CarDTO]()
    func update(cars: [CarDTO]) {
        self.cars = cars
    }
}
extension DetailCarTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CarShopDetailCell.id) as? CarShopDetailCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
}
