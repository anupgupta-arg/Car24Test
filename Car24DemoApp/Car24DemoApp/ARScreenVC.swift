//
//  ARScreenVC.swift
//  Car24DemoApp
//
//  Created by Uniqolabel Developer on 05/01/19.
//  Copyright © 2018 GeekGuns. All rights reserved.
//

import UIKit
import ARKit

class ARScreenVC: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var arTutorialView: UIView!
    @IBOutlet weak var arTutorialScrollView: UIScrollView!
    @IBOutlet weak var arTutorialPageControll: UIPageControl!
    
    @IBOutlet weak var arTutorialDoneButton: UIButton!
    
    var currentNode: SCNNode!
    var isNodeAvailable  = false
    var xAxis : Float = 0.0
    var yAxis : Float = 0.0
    var zAxis : Float = -1.5
    var currentAngleY: Float = 0.0
    
    //Not Really Necessary But Can Use If You Like
    var isRotating = false
    var destinationARImagePath : String = ""
    var arImageFileUrl : String = ""
    
//    let arCupUrl = "https://s3.ap-south-1.amazonaws.com/uniqolabel-product-arimages/test/100/cup.scn";
//    let arImageUrl2 = "https://s3.ap-south-1.amazonaws.com/uniqolabel-product-arimages/test/100/chair.scn";
//    
//    let arWindUrl = "https://s3.ap-south-1.amazonaws.com/uniqolabel-product-arimages/test/100/Wind.scn";
    
    var childNodeName = "chair";
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setARTutorialImageView()

        configureLighting()
        
        
        //       1. Add Tap Gesture
        addTapGestureToSceneView()
        
        //       2. Add Pinch Gesture
        addPinchGestureToSceneView()
        
        //       3. Add Rotation Gesture
        addRotationGestureToSceneView()
        
        //       4. Add Pan Gesture
        addPanGestureToSceneView()
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.isNavigationBarHidden = true;
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    
    
    private func getChildNodeName(from nameUrl: String) -> String{
        
        let nameUrlArray = nameUrl.split(separator: "/")
        let lastName = nameUrlArray.last
//        print("lastName",lastName as Any)
        let lastNameArray = lastName?.split(separator: ".")
        let nodeName = lastNameArray![0]
        
        return String(nodeName)
        
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    func addARObjectOffline(x: Float = 0, y: Float = 0, z: Float = -0.5) {
//        print("childNodeName>>",childNodeName)
        
        guard let arScene = SCNScene(named: "art.scnassets/audi.scn"),
            let arNode = arScene.rootNode.childNode(withName: "audi", recursively: false)
            else {
         print("Not Found")
        return }
        
//        guard let arScene = SCNScene(named: "Models.scnassets/chair/chair.scn"),
//            let arNode = arScene.rootNode.childNode(withName: childNodeName, recursively: false)
//            else {
//                print("Not Found")
//                return
//        }
        

        arNode.position = SCNVector3(x,y,z)
        
        zAxis = z
        if isNodeAvailable {
            currentNode.position = SCNVector3(x,y,z)
        }else{
            isNodeAvailable = true
            currentNode = arNode
            sceneView.scene.rootNode.addChildNode(arNode)
        }
         
    }
    
    func addARObject(x: Float = 0, y: Float = 0, z: Float = -0.5) {
        
        let aRUrl : URL = URL(string :arImageFileUrl)!
        do {
//            print("aRUrl",aRUrl)
//            print("childNodeName",childNodeName)
            let arScene = try SCNScene(url: aRUrl  , options: nil)
            
            let arNode = arScene.rootNode.childNode(withName: childNodeName, recursively: false)
            guard arNode != nil else {
               self.showAlert(message: "Something went wrong Please try Again")
                return
            }
         
            arNode?.position = SCNVector3(x,y,z)
            
            zAxis = z
            if isNodeAvailable {
                currentNode.position = SCNVector3(x,y,z)
            }else{
                isNodeAvailable = true
                currentNode = arNode
                sceneView.scene.rootNode.addChildNode(arNode!)
            }
        }
        catch {
            print("errrrrororororor")
        }
        
    }
    
    // MARK: - Gesture
    
    //    1 . Tap Gesture
    func addTapGestureToSceneView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    //    2 . Pinch Gesture
    func addPinchGestureToSceneView() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        self.view.addGestureRecognizer(pinchGesture)
    }
    
    //    3 . Rotation Gesture
    func addRotationGestureToSceneView() {
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
        self.view.addGestureRecognizer(rotateGesture)
    }
    
    //    4 . Pan Gesture
    func addPanGestureToSceneView() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    
    // MARK: - Implement Gesture
    @objc func didTap(_ gesture: UITapGestureRecognizer) {
//        print("didTap")
        
        let tapLocation = gesture.location(in: sceneView)
        //        print("tapLocation",tapLocation)
        let hitTestResults = sceneView.hitTest(tapLocation)
        
        guard let _ = hitTestResults.first?.node else {
            
            let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
            
            if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                let translation = hitTestResultWithFeaturePoints.worldTransform.translation
//                addARObject(x: translation.x, y: translation.y, z: translation.z)
                addARObjectOffline(x: translation.x, y: translation.y, z: translation.z)
            }
            return
        }
      
        
    }
    
    @objc func didPinch(_ gesture: UIPinchGestureRecognizer) {
//        print("didPinch")
        
        guard let _ = currentNode else { return }
        var originalScale = currentNode?.scale
        
        switch gesture.state {
        case .began:
            originalScale = currentNode?.scale
            gesture.scale = CGFloat((currentNode?.scale.x)!)
        case .changed:
            guard var newScale = originalScale else { return }
            if gesture.scale < 0.02{ newScale = SCNVector3(x: 0.009, y: 0.009, z: 0.009) }else if gesture.scale > 0.1{
                newScale = SCNVector3(0.1, 0.1, 0.1)
            }else{
                newScale = SCNVector3(gesture.scale, gesture.scale, gesture.scale)
            }
            currentNode?.scale = newScale
        case .ended:
            guard var newScale = originalScale else { return }
            if gesture.scale < 0.02{ newScale = SCNVector3(x: 0.009, y: 0.009, z: 0.009) }else if gesture.scale > 0.1{
                newScale = SCNVector3(0.1, 0.1, 0.1)
            }else{
                newScale = SCNVector3(gesture.scale, gesture.scale, gesture.scale)
            }
            currentNode?.scale = newScale
            gesture.scale = CGFloat((currentNode?.scale.x)!)
        default:
            gesture.scale = 1.0
            originalScale = nil
        }
        
        
        
    }
    
    @objc func didRotate(_ gesture: UIRotationGestureRecognizer) {
//        print("didRotate")
        
        
        //1. Get The Current Rotation From The Gesture
        var rotation = Float(gesture.rotation)
//        print("rotation",rotation)
        
        rotation = -1.0 * rotation
        //2. If The Gesture State Has Changed Set The Nodes EulerAngles.y
        if gesture.state == .changed{
            isRotating = true
            currentNode.eulerAngles.y = currentAngleY + rotation
        }
        
        //3. If The Gesture Has Ended Store The Last Angle Of The Cube
        if(gesture.state == .ended) {
            currentAngleY = currentNode.eulerAngles.y
            isRotating = false
        }
       
        
    }
    
    @objc func didPan(_ gesture: UIPanGestureRecognizer) {

        gesture.maximumNumberOfTouches = 1
        
        let results = self.sceneView.hitTest(gesture.location(in: gesture.view), types: ARHitTestResult.ResultType.featurePoint)
        guard let result: ARHitTestResult = results.first else {
            return
        }
        
        let position = SCNVector3Make(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
        currentNode.position = position
        
        
    }
    
    
   
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func arTutorialDoneButtonAction(_ sender: Any) {
        
        let buttonTag = (sender as AnyObject).tag
        switch buttonTag {
        case 11:
            arTutorialView.isHidden = true
           
        case 21:
            
            arTutorialView.isHidden = false
            
        default:
            arTutorialView.isHidden = false
        }
    }
    
    
    
    
}

extension ARScreenVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        
        return self
    }
    
    //Show Downloaded File
    func showFile(at path: String)
    {
        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
        if isFileFound == true
        {
            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            viewer.delegate = self
            viewer.presentPreview(animated: true)
        }
    }
    
    
}

extension ARScreenVC : UIScrollViewDelegate {
    
    private func setARTutorialImageView(){
        let imageView1 : UIImageView
        let imageView2 : UIImageView
        let imageView3 : UIImageView
        let imageView4 : UIImageView

        
        let img1 : UIImage = #imageLiteral(resourceName: "tap")
        let img2 : UIImage = #imageLiteral(resourceName: "pinch")
        let img3 : UIImage = #imageLiteral(resourceName: "rotate")
        let img4 : UIImage = #imageLiteral(resourceName: "pan")
       
        
        imageView1 = UIImageView.init(image: img1)
        imageView2 = UIImageView.init(image: img2)
        imageView3 = UIImageView.init(image: img3)
        imageView4 = UIImageView.init(image: img4)

        
        imageView1.contentMode = .scaleAspectFit
        imageView2.contentMode = .scaleAspectFit
        imageView3.contentMode = .scaleAspectFit
        imageView4.contentMode = .scaleAspectFit
       
        
        arTutorialView.layoutIfNeeded()
        
        self.arTutorialScrollView.frame = CGRect(x:0, y:0, width: self.arTutorialView.frame.size.width , height:self.arTutorialView.frame.size.height);
        arTutorialScrollView.layer.cornerRadius = 5.0
        
        let ScreenWidth : CGFloat = self.arTutorialView.frame.width
        let ScreeHeight : CGFloat = self.arTutorialView.frame.height

        
        imageView1.frame = CGRect(x:0, y:0, width:ScreenWidth, height:ScreeHeight);
        imageView2.frame = CGRect(x:ScreenWidth, y:0, width:ScreenWidth, height:ScreeHeight);
        imageView3.frame = CGRect(x:ScreenWidth * 2, y:0, width:ScreenWidth, height:ScreeHeight);
        imageView4.frame = CGRect(x:ScreenWidth * 3, y:0, width:ScreenWidth, height:ScreeHeight);

        
        self.arTutorialScrollView.addSubview(imageView1);
        self.arTutorialScrollView.addSubview(imageView2);
        self.arTutorialScrollView.addSubview(imageView3);
        self.arTutorialScrollView.addSubview(imageView4);
        self.arTutorialScrollView.contentSize = CGSize(width: ScreenWidth*4, height: ScreeHeight)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        
        let pageWidth = arTutorialView.frame.width
        let currentPage = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
        self.arTutorialPageControll.currentPage = Int(currentPage);
        if currentPage == 3 {
            arTutorialDoneButton.setTitle("Done", for: .normal)
        }
        else{
            arTutorialDoneButton.setTitle("Skip", for: .normal)
        }
        
        
    }
    
}
