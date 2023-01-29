//
//  MapViewController.swift
//  UsedCarShop
//
//  Created by 김동준 on 2023/01/28.
//

import SnapKit
import NMapsMap
import RxAppState
import ReactorKit

final class ArroundShopMapViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    func bind(reactor: ArroundShopMapReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        userLocationTapGesture.rx
            .event
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { _ in Reactor.Action.tapUserLocation }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.locationPermission }
            .distinctUntilChanged()
            .bind { permission in
                print("success to change! \(permission)")
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.userPoint }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] userLocation in
                guard let self = self else { return }
                guard let userLocation = userLocation else { return }
                self.setCameraWithUser(to: userLocation)
            }.disposed(by: disposeBag)
    }
    
    private let mapView: NMFNaverMapView = {
        let mapView = NMFNaverMapView()
        mapView.showLocationButton = false
        mapView.showZoomControls = false
        mapView.showScaleBar = false
        mapView.mapView.minZoomLevel = 13.0
        mapView.mapView.maxZoomLevel = 20.0
        return mapView
    }()
    
    private let userLocationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.shadow()
        let userLocationView = UIImageView()
        userLocationView.image = UIImage(named: "my_location")
        userLocationView.contentMode = .scaleToFill
        userLocationView.clipsToBounds = true
        view.addSubview(userLocationView)
        userLocationView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(10)
            make.leading.top.equalToSuperview().offset(10)
        }
        return view
    }()
    private let userLocationTapGesture = UITapGestureRecognizer()
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
        view.addSubviews(mapView, userLocationView)
        userLocationView.addGestureRecognizer(userLocationTapGesture)
        layout()
    }
    
    func layout() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        userLocationView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.width.height.equalTo(50)
        }
    }
    
    func setCameraWithUser(to point: Location) {
        setCamera(to: point)
        let locationOverlay = mapView.mapView.locationOverlay
        locationOverlay.hidden = false
        locationOverlay.location = NMGLatLng(lat: point.lat, lng: point.lng)
        locationOverlay.icon = NMFOverlayImage(name: "user_location")
    }
    
    func setCamera(to point: Location) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: point.lat, lng: point.lng))
        cameraUpdate.animation = .easeIn
        mapView.mapView.moveCamera(cameraUpdate)
    }
}
