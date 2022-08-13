import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController, UITextFieldDelegate
{
    var db: Firestore!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var labelErrorMsg: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        db = Firestore.firestore()
    }

    @IBAction func RegisterButton(_ sender: Any)
    {
        
        //confirm no field is empty
        guard let email_address = txtEmail.text, !email_address.isEmpty,
              let username = txtName.text, !username.isEmpty,
              let password = txtPassword.text, !password.isEmpty,
              let confirm_pw = txtConfirmPassword.text, !confirm_pw.isEmpty
        else
        {
            labelErrorMsg.text = "Missing field data"
            labelErrorMsg.isHidden = false
            return
        }
        
        var uid = ""
        if (password == confirm_pw) //ensure there is a match between pw and confirm_pw
        {
            //firebase- create user with email and password
            FirebaseAuth.Auth.auth().createUser(withEmail: email_address, password: password, completion: {[weak self]result, error in
                guard let strongSelf = self else
                {
                    return
                }
                guard error == nil else
                {
                    self!.labelErrorMsg.text = "Account creation failed. Possible reasons: (1). email has already been registered (2).incorrect email format (3).password is too short"
                    self!.labelErrorMsg.isHidden = false
                    return
                }
                
                //query current user id
                let user = Auth.auth().currentUser
                if let user = user
                {
                    uid = user.uid
                }
                //save account to Firebase database, in the collection named "Accounts"
                strongSelf.saveAccountToFirebaseDatabase(username: username,
                                                         uid: uid,
                                                         email_address: email_address,
                                                         password: password)
                
                //close the register page, back to login page
                strongSelf.dismiss(animated: true, completion: nil)
            })
            
        } else
        {
            self.labelErrorMsg.text = "Password does not match"
            self.labelErrorMsg.isHidden = false
            self.txtPassword.text = ""
            self.txtConfirmPassword.text = ""
        }
    }
    
    func saveAccountToFirebaseDatabase(username: String, uid: String, email_address: String, password: String)
    {
        //use user id as document id
        db.collection("Accounts").document("\(uid)").setData([
            "username": username,
            "email_address": email_address,
            "password": password
        ]) { err in
            if let err = err {
                print("RegisterViewControllerError: saveAccountToFirebaseDatabase -> writing document: \(err)")
            } else {
                print("RegisterViewControllerError: saveAccountToFirebaseDatabase -> Document successfully written!")
            }
        }
    }
}
