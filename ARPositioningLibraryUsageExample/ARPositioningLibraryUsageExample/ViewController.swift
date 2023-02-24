//
//  ViewController.swift
//  ExamplePersistenceAPP_ARView
//
//  Created by Pietro Barone on 07/10/22.
//

import UIKit
import RealityKit
import ARKit
import ARPositioning


class ViewController: UIViewController{
    
    @IBOutlet weak var arView: ARView!

        
    private var arPositioning: ARPositioning!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //initialize ARPositioning
        self.arPositioning = ARPositioning(arView: arView)
        
        arPositioning.setBuilding(building: Building(id: "a", name: "BuildingName", coord: CLLocationCoordinate2D(latitude: 43.779845104199524, longitude: 7.670822335471198)))
        let primoPiano = FloorInfo(id: "0", number: 0, maxWidth: 12.16, maxLenght: 13.75, floorPlan: UIImage(named: "floorplan")!, mapReferenceTriangle: Triangle(point1: CGPoint(x: 670,y: 1365), point2: CGPoint(x: 1030, y: 1360), point3: CGPoint(x: 1026, y: 968)), height: 3)
        let secondoPiano = FloorInfo(id:"1", number: 1,  maxWidth: 12.16, maxLenght: 13.75, floorPlan: UIImage(named: "floorplan")!, mapReferenceTriangle: Triangle(point1: CGPoint(x: 670,y: 1365), point2: CGPoint(x: 1030, y: 1360), point3: CGPoint(x: 1026, y: 968)),height: 3)

        arPositioning.setFloorInfo(floorsInfo: [primoPiano, secondoPiano])

        arView.session.delegate = arPositioning
        //arPositioning.arSessionDelegate = self //allows to have another delegate
        arPositioning.addConfigurationButton() //adds a button to visualize the mapping points on the planimetry
        arPositioning.addToolbar() //adds a toolbar to the arview to easily manage session load and save
        arPositioning.manageMappingPoint() //tells the library to manage the insertion of the mapping points
        
        arPositioning.setSessionEventDelegate(sessionEventDelegate: self) //receive session status updates
        arPositioning.addPositionObserver(positionObserver: self) //receive position updates
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.arPositioning.resetMap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
    }
}


//MARK: Delegates && Observer
extension ViewController: PositionObserver, SessionEventDelegate{
    func onFloorUpdate(_ newFloor: Int) {
        view.showToast(text: "New floor: \(newFloor)")
    }
    func onPositionUpdate(_ newPosition: Position) {
        print("New position: \(newPosition.coordinates), heading: \(newPosition.heading)")
    }
    
    func onSessionEventChanged(event: SessionEvent) {
        if event == .saved{
            view.showToast(text: "Session saved", pos: .center)
        }else if event == .loading{
            view.showToast(text: "Loading session", pos: .center)
        }else if event == .failedRetrievingMap{
            view.showToast(text: "Failed retrieving map", pos: .center)
        }else if event == .failedSave{
            view.showToast(text: "Save failed", pos: .center)
        }
    }
    
}















extension UIView{
    enum Position{
        case top
        case bottom
        case center
    }
    func showToast(text: String, pos: Position = .top){
        let deadlineTime = DispatchTime.now() + .seconds(2)
        let popupView = UIView()
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.backgroundColor = .black
        popupView.layer.opacity = 0.4
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOpacity = 0.3
        popupView.layer.shadowOffset = CGSize(width: 5, height: 3)
        popupView.layer.shadowRadius = 4.0
        popupView.layer.cornerRadius = 45
        if pos == .top{
            popupView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] // only round the bottom corners
        }else if pos == .bottom{
            popupView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        self.addSubview(popupView)
        
        let titleView = UIView() /// container for title label.
        titleView.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(titleView)
        
        let titleLabel = UILabel() /// the title label itself
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.adjustsFontSizeToFitWidth = true
        titleView.addSubview(titleLabel)
        titleLabel.text = text
        
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            popupView.removeFromSuperview()
        }
        
        if pos == .top {
            NSLayoutConstraint.activate([
                
                /// constrain `popupView`
                popupView.topAnchor.constraint(equalTo: self.topAnchor),
                popupView.rightAnchor.constraint(equalTo: self.rightAnchor),
                popupView.leftAnchor.constraint(equalTo: self.leftAnchor),
                
                
                /// constrain `titleView`
                titleView.topAnchor.constraint(equalTo: popupView.safeAreaLayoutGuide.topAnchor), /// most important part!
                titleView.heightAnchor.constraint(equalToConstant: 30), /// will also stretch `popupView` vertically
                titleView.rightAnchor.constraint(equalTo: popupView.rightAnchor),
                titleView.leftAnchor.constraint(equalTo: popupView.leftAnchor),
                titleView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor),
                
                /// constrain `titleLabel`
                titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor)
            ])
        }
        if pos == .bottom {
            NSLayoutConstraint.activate([
                
                /// constrain `popupView`
                popupView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                popupView.rightAnchor.constraint(equalTo: self.rightAnchor),
                popupView.leftAnchor.constraint(equalTo: self.leftAnchor),
                
                
                /// constrain `titleView`
                titleView.topAnchor.constraint(equalTo: popupView.safeAreaLayoutGuide.topAnchor), /// most important part!
                titleView.heightAnchor.constraint(equalToConstant: 100), /// will also stretch `popupView` vertically
                titleView.rightAnchor.constraint(equalTo: popupView.rightAnchor),
                titleView.leftAnchor.constraint(equalTo: popupView.leftAnchor),
                titleView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor),
                
                /// constrain `titleLabel`
                titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor)
            ])
        }
        if pos == .center{
            NSLayoutConstraint.activate([
                
                /// constrain `popupView`
                popupView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                popupView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                popupView.rightAnchor.constraint(equalTo: self.rightAnchor),
                popupView.leftAnchor.constraint(equalTo: self.leftAnchor),
                
                
                /// constrain `titleView`
                titleView.topAnchor.constraint(equalTo: popupView.safeAreaLayoutGuide.topAnchor), /// most important part!
                titleView.heightAnchor.constraint(equalToConstant: 100), /// will also stretch `popupView` vertically
                titleView.rightAnchor.constraint(equalTo: popupView.rightAnchor),
                titleView.leftAnchor.constraint(equalTo: popupView.leftAnchor),
                titleView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor),
                
                /// constrain `titleLabel`
                titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor)
            ])
        }
        
    }
}

extension Float{
    func toStr() -> String{
        return String(self)
    }
}

extension Int{
    func toStr() -> String{
        return String(self)
    }
}

extension Double{
    func toStr() -> String{
        return String(self)
    }
}

extension ARAnchor{
    func toVectorFloat3() -> vector_float3{
        return vector_float3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
}

extension ARFrame.WorldMappingStatus{
    func description() -> String{
        switch self{
        case .mapped: return "mapped"
        case .limited: return "limited"
        case .extending: return "extending"
        case .notAvailable: return "not available"
        @unknown default:
            return "not available"
        }
    }
}
