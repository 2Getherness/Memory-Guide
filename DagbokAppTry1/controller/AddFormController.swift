
import UIKit
import Firebase
import FirebaseStorage
import MobileCoreServices
import CoreLocation
import CoreData


class AddFormController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var myLocation: CLLocation = CLLocation()
    
    var noteID : String = ""
    var date : NSData!
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var detailField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    //Hiding image constrints when there is no image
    @IBOutlet weak var verticalOrientationImageHeight: NSLayoutConstraint!
    @IBOutlet weak var landscapeOrientaionImageWidth: NSLayoutConstraint!
    
    @IBOutlet weak var langscapeOrientationImageTrailConstrant: NSLayoutConstraint!
    @IBOutlet weak var landscapeOrientationTitleLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalOrientationalTitleWidthConstrant: NSLayoutConstraint!
    @IBOutlet weak var verticalOrientationSaveBottomConstrant: NSLayoutConstraint!
    
    
    
    var ref: DatabaseReference?
    var newRef: DatabaseReference?
    
    var currentTime: String = ""
    var fieldClicked: Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.placeholder = ""
        detailField.placeholder = ""
        
        ref = Database.database().reference()
        findMyLocation()
        if imageView.image == nil {
            verticalOrientationImageHeight.constant = 0.0
        } else {
            UIView.animate(withDuration: 0.5) {
                self.verticalOrientationImageHeight.constant = 281.0
            }
        }
        
    }
    override func viewDidLayoutSubviews() {
        print("5  viewDidLayoutSubviews" + "\n")
        
        if imageView.image == nil {
            verticalOrientationImageHeight.constant = 0.0
            verticalOrientationSaveBottomConstrant.constant = 250.0
            landscapeOrientaionImageWidth.constant = 0.0
            landscapeOrientationTitleLeadingConstraint.constant = 20
        } else {
            self.verticalOrientationImageHeight.constant = 281.0
            self.landscapeOrientaionImageWidth.constant = 375.0
            verticalOrientationSaveBottomConstrant.constant = 0.0
//            if fieldClicked == true {
//                print("Clicked")
//                verticalOrientationImageHeight.constant = 0.0
//                verticalOrientationSaveBottomConstrant.constant = 250.0
//                landscapeOrientaionImageWidth.constant = 0.0
//                landscapeOrientationTitleLeadingConstraint.constant = 20
//                titleField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: UIControlEvents.touchDown)
//                UIView.animate(withDuration: 3, animations: {
//                    self.view.layoutIfNeeded()
//                    self.titleField.placeholder = "Write title"
//                    self.detailField.placeholder = "Write more detail..."
//                }, completion: nil)
//            } else {
//                print("not Clicked")
//            }
            landscapeOrientationTitleLeadingConstraint.constant = langscapeOrientationImageTrailConstrant.constant
            
            UIView.animate(withDuration: 3) {
                self.view.layoutIfNeeded()
                self.titleField.placeholder = "Write title"
                self.detailField.placeholder = "Write more detail..."
            }
        }
    }
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == titleField && imageView.image != nil {
            fieldClicked = true
            UIView.animate(withDuration: 2, animations: {
                self.verticalOrientationImageHeight.constant = 0.0
                self.verticalOrientationSaveBottomConstrant.constant = 250.0
                self.landscapeOrientaionImageWidth.constant = 0.0
                self.landscapeOrientationTitleLeadingConstraint.constant = 20
            }, completion: nil)
        } else if textField == detailField {
            fieldClicked = false
            print("Detail field clicked")
        }
    }
    
    @IBAction func showCamera(_ sender: UIButton) {
        // Metoden hämtas från Camera.swift
        fieldClicked = true
        openCamera()
    }
    
    @IBAction func submittingForm(_ sender: Any) {
        // uploadDataToDatabase() hämtas från UploadDataToDB.swift
        uploadDataToDatabase()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    func animate(duration: Double) {
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
            self.titleField.placeholder = "Write title"
            self.detailField.placeholder = "Write more detail..."
        }, completion: nil)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}

extension AddFormController: UITextFieldDelegate {
    
    // keypad disappears by clicking return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.titleField.resignFirstResponder()
        self.detailField.resignFirstResponder()
        
        return true
    }
    
    //KeyPad dissappears when i click outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.titleField.resignFirstResponder()
        self.detailField.resignFirstResponder()
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        print("9 View did appear" + "\n")
    //    }
    //
    //    override func viewWillAppear(_ animated: Bool) {
    //        print("1  View Will Appear" + "\n")
    //    }
    //    override func viewLayoutMarginsDidChange() {
    //        print("2  AnyviewLayoutMarginsDidChange" + "\n")
    //    }
    //    override func viewWillLayoutSubviews() {
    //        print("3  AnyviewWillLayoutSubviews" + "\n")
    //    }
    //    override func viewSafeAreaInsetsDidChange() {
    //        print("4  viewSafeAreaInsetsDidChange" + "\n")
    //    }
    
    //    override func viewDidDisappear(_ animated: Bool) {
    //        print("6  ViewDidDisappear" + "\n")
    //    }
    //    override func viewWillDisappear(_ animated: Bool) {
    //        print("7  View Will Disappear" + "\n")
    //    }
    //    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    //        print("8  view Will Transition ********************" + "\n")
    //    }
    
}


extension NSLayoutConstraint {
    func constratWithMultipler(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
