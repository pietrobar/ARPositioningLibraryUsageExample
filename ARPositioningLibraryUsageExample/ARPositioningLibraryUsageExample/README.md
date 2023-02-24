
#  ARPositioning

  

  

>This library allows the developer to access the position and orientation of the device in an indoor space and to easily manage the ARSession to save and then retrieve the previously saved session. It uses the position of three anchors set by the user to convert coordinates from the AR coordinates system to the coordinates system of the planimetry set by the developer.

  

  

  

## Set up

To set up the library there are a few steps to do

  

### Initialization:

To initialize the ARPositioning class specifying floors:

  

```swift

self.arPositioning = ARPositioning(arView: arView)

arPositioning.setBuilding(building: Building(id: "a", name: "BuildingName", coord: CLLocationCoordinate2D(latitude: 43.779845104199524, longitude: 7.670822335471198)))

let floor0 = FloorInfo(id: "0", number: 0, maxWidth: 12.16, maxLenght: 13.75, floorPlan: UIImage(named: "floorplan")!, mapReferenceTriangle: Triangle(point1: CGPoint(x: 670,y: 1365), point2: CGPoint(x: 1030, y: 1360), point3: CGPoint(x: 1026, y: 968)), height: 3)

let floor1 = FloorInfo(id:"1", number: 1,  maxWidth: 12.16, maxLenght: 13.75, floorPlan: UIImage(named: "floorplan")!, mapReferenceTriangle: Triangle(point1: CGPoint(x: 670,y: 1365), point2: CGPoint(x: 1030, y: 1360), point3: CGPoint(x: 1026, y: 968)),height: 3)

arPositioning.setFloorInfo(floorsInfo: [floor0, floor1])

```

  

To initialize the ARPositioning class using just one floor as mapping:

  

```swift

self.arPositioning = ARPositioning(arView: arView,mapReferenceTriangle: Triangle(point1: CGPoint(x: 670,y: 1365), point2: CGPoint(x: 1030, y: 1360), point3: CGPoint(x: 1026, y: 968)))

```

### Settings:

```swift

arView.session.delegate = arPositioning //this allows ARPositioning to act as intermediary between ARKit and your application

arPositioning.arSessionDelegate = self //even if the session delegate is set as arPositioning you can specify your class as one, because ARPositioning will send you all the updates
 

arPositioning.addConfigurationButton() //adds a button to visualize the mapping points on the planimetry for each specified floor


arPositioning.addToolbar() //adds a toolbar to the arview to easily manage session load and save

arPositioning.manageMappingPoint() //tells the library to manage the insertion of the mapping points

arPositioning.setSessionEventDelegate(sessionEventDelegate: self) //receive session status updates
 

arPositioning.addPositionObserver(positionObserver: self) //receive position updates

```

  

### Receive updates:

To receive the ARSessionDelegates updates you just have adopt the ARSessionDelegates protocol and implement the function you need as you would do normally.

  

The SessionEventDelegate update its delegate about the events of the saving/loading of a session.

The PositionObserver allows many observer to receive the position updates.

Here's an example of both:

  

```swift

extension  ViewController: PositionObserver, SessionEventDelegate{
    //position observer methods
    func onFloorUpdate(_ newFloor: Int) {
        view.showToast(text: "New floor: \(newFloor)")
    }
    func onPositionUpdate(_ newPosition: Position) {
        print("New position: \(newPosition.coordinates), heading: \(newPosition.heading)")
    }

  
    //SessionEventDelegate methods
    func  onSessionEventChanged(event: SessionEvent) {
        if event == .saved{
            print("session saved")
        }else if event == .loading{
            print("Loading session")
        }else if event == .failedRetrievingMap{
            print("Failed retrieving map")
        }else if event == .failedSave{
            print("save failed)
        }
    }
}
```
