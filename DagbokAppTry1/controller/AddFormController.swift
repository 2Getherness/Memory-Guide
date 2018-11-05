
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
    
    var ref: DatabaseReference?
    var newRef: DatabaseReference?
    
    var currentTime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        findMyLocation()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    @IBAction func showCamera(_ sender: UIButton) {
        // Metoden hämtas från Camera.swift
        openCamera()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submittingForm(_ sender: Any) {
        // uploadDataToDatabase() hämtas från UploadDataToDB.swift
        uploadDataToDatabase()
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
    
    
    
    
}
