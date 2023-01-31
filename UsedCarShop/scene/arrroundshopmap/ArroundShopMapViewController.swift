//
//  MapViewController.swift
//  UsedCarShop
//
//  Created by 김동준 on 2023/01/28.
//

import SnapKit
import NMapsMap
import RxAppState
import RxRelay
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
                print("vc success to change! \(permission)")
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.userPoint }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] userLocation in
                guard let self = self else { return }
                guard let userLocation = userLocation else { return }
                print("vc setCamera")
                self.setCameraWithUser(to: userLocation)
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.carshops }
            .filter { $0.count > 0 }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance )
            .bind { [weak self] carshops in
                guard let self = self else { return }
                let markers = self.makeCarShopMarkers(with: carshops, markerTapEventRelay: self.markerTapEventRelay)
                for marker in markers {
                    self.addMarker(to: self.mapView, from: marker)
                }
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
    private lazy var markerTapEventRelay = PublishRelay<Location>()
    
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
        locationOverlay.iconWidth = Marker.UserLocation.width
        locationOverlay.iconHeight = Marker.UserLocation.height
    }
    
    func setCamera(to point: Location) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: point.lat, lng: point.lng))
        cameraUpdate.animation = .easeIn
        mapView.mapView.moveCamera(cameraUpdate)
    }
    
    func addMarker(to mapView: NMFNaverMapView, from marker: NMFMarker) {
        marker.mapView = mapView.mapView
    }
    
    func makeCarShopMarkers(with carshops: [CarShopDTO], markerTapEventRelay: PublishRelay<Location>) -> [NMFMarker] {
        var carshopMarkers = [NMFMarker]()
        for carshop in carshops {
            carshopMarkers.append(makeCarShopMarker(with: carshop, markerTapEventRelay: markerTapEventRelay))
        }
        return carshopMarkers
    }
    
    func makeCarShopMarker(with carshop: CarShopDTO, markerTapEventRelay: PublishRelay<Location>) -> NMFMarker {
        let marker = NMFMarker(position: NMGLatLng(lat: carshop.location.lat, lng: carshop.location.lng), iconImage: NMFOverlayImage(name: "recycler_car"))
        marker.width = Marker.CarShopMarker.width
        marker.height = Marker.CarShopMarker.height
        marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
            markerTapEventRelay.accept(carshop.location)
            return true
        }
        return marker
    }
}
enum Marker {
    enum CarShopMarker {
        static let width: Double = 45.0
        static let height: Double = 45.0
    }
    
    enum UserLocation {
        static let width: Double = 45.0
        static let height: Double = 45.0
    }
}
