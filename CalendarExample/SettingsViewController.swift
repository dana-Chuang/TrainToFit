import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class SettingsViewController: UIViewController
{
    var db: Firestore!
    let uid : String = (Auth.auth().currentUser?.uid)!
    
    @IBOutlet weak var txtFieldUsername: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPW: UITextField!
    @IBOutlet weak var txtFieldPWConfirm: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        
    }
    
    @IBAction func SaveChangesOfProfile(_ sender: Any)
    {
        
        //back to Home page
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func getHelp(_ sender: Any)
    {
        if let viewController = storyboard?.instantiateViewController(identifier: "help_centre") as? HelpCentreViewController
        {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func DeactivateAccount(_ sender: Any)
    {
        
    }
}
