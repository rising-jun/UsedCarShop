//
//  MapViewController.swift
//  UsedCarShop
//
//  Created by 김동준 on 2023/01/28.
//

import SnapKit
import NMapsMap

class ArroundShopMapViewController: UIViewController {
    
    private let mapView: NMFNaverMapView = {
        let mapView = NMFNaverMapView()
        mapView.showLocationButton = false
        mapView.showZoomControls = false
        mapView.showScaleBar = false
        mapView.mapView.minZoomLevel = 13.0
        mapView.mapView.maxZoomLevel = 20.0
        return mapView
    }()
    
    private let permisssionManager = PermissionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAttribute()
        permisssionManager.updateLocation = { lat, lng in
            print("update lat \(lat), lng \(lng)")
        }
        
        permisssionManager.whenPermissionDeniend = {
            print("permission denined")
        }
        
        permisssionManager.requestUseLocationPermission()
        Task {
            let repository = CarShopRespository()
            let model = await repository.requestMockCarShop()
            print(model?.count)
        }
    }
}
private extension ArroundShopMapViewController {
    func viewAttribute() {
        view.backgroundColor = .white
        view.addSubview(mapView)
        layout()
    }
    
    func layout() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
