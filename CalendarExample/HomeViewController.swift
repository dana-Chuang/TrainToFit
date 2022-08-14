import UIKit
import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class HomeViewController: UIViewController
{
    var db: Firestore!
    let uid : String = (Auth.auth().currentUser?.uid)!
    var imgPicker: UIImagePickerController!
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var CustomMyPlanBtn: UIButton!
    @IBOutlet weak var img_profile: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //fetch username in viewWillAppear so that it will refresh even after user changes it in the setting page
        showUserName()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        //settings on image view
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        img_profile.isUserInteractionEnabled = true
        img_profile.addGestureRecognizer(imageTap)
        img_profile.layer.cornerRadius = img_profile.frame.size.width/2
        //subviews to be clipped to the bounds of the receiver
        img_profile.clipsToBounds = true
        
        //settings on image picker
        imgPicker = UIImagePickerController()
        imgPicker.allowsEditing = true
        imgPicker.sourceType = .photoLibrary
        imgPicker.delegate = self
        
        showProfileImg()
    }
    
    @objc func openImagePicker(_sender:Any)
    {
        //open image picker
        self.present(imgPicker, animated: true)
    }
    
    func showUserName()
    {
        //fetch username and show it in the middle
        db.collection("Accounts").document("\(uid)").getDocument{ (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let db_username = data?["username"] as? String ?? "Anonymous"
                self.username.text = db_username
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @IBAction func LogoutButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadProfileImg(_ image:UIImage)
    {
        let storageRef = Storage.storage().reference().child("user/profileImg/\(uid)")
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        // Create file metadata including the content type
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        storageRef.putData(imageData, metadata: metadata)
    }
    
    func showProfileImg()
    {
        // Create reference to the file whose metadata we want to retrieve
        let storafeProfileRef = Storage.storage().reference().child("user/profileImg/\(uid)")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        storafeProfileRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
          } else {
            // Data for "images/island.jpg" is returned
              self.img_profile.image = UIImage(data: data!)
          }
        }
    }
}

extension HomeViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImg = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.img_profile.image = pickedImg
            self.uploadProfileImg(pickedImg)
        }
        picker.dismiss(animated: true)
    }
    
}
