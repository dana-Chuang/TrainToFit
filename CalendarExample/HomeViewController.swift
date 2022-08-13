import UIKit
import Foundation
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController
{
    var db: Firestore!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var CustomMyPlanBtn: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        db = Firestore.firestore()
        showUserName()
    }
    
    func showUserName()
    {
        //fetch username and show it in the middle
        let uid : String = (Auth.auth().currentUser?.uid)!
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
    
    
}
