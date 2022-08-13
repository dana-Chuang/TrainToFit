import Foundation
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController
{
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var labelErrorMsg: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func LoginButton(_ sender: Any) {
        login()
    }
    
    func login()
    {
        //confirm no field is empty
        guard let email = txtEmail.text, !email.isEmpty,
              let password = txtPassword.text, !password.isEmpty
        else
        {
            labelErrorMsg.text = "Missing field data"
            labelErrorMsg.isHidden = false
            txtEmail.text = ""
            txtPassword.text = ""
            return
        }
        
        //get auth instance
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self]result, error in
            guard let strongSelf = self else
            {
                return
            }
            guard error == nil else
            {
                self!.labelErrorMsg.text = "No account found. Please press Register Button below"
                self!.labelErrorMsg.isHidden = false
                self!.txtEmail.text = ""
                self!.txtPassword.text = ""
                return
            }
            
            //swift to Home page
            if let controller = strongSelf.storyboard?.instantiateViewController(withIdentifier: "HomeNavigation") as? UINavigationController {
                self!.txtEmail.text = ""
                self!.txtPassword.text = ""
                self!.labelErrorMsg.text = ""
                self!.labelErrorMsg.isHidden = true
                strongSelf.present(controller, animated: true, completion: nil)
            } else {
                print("instantiateViewController has something wrong.")
            }
            
        })
    }
    
}
