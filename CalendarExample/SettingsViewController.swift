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
    @IBOutlet weak var labelErrMsg: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        db = Firestore.firestore()
        ShowUserInfo()
    }
    
    func ShowUserInfo()
    {
        db.collection("Accounts").document("\(uid)").getDocument{ (document, error) in
            if let document = document, document.exists {
                self.txtFieldUsername.text = "\(document.data()?["username"] ?? "Anonymous")"
                self.txtFieldEmail.text = "\(document.data()?["email_address"] ?? "Anonymous")"
            }
        }
    }
    
    @IBAction func SaveChangesOfProfile(_ sender: Any)
    {
        let userEmail = FirebaseAuth.Auth.auth().currentUser?.email
        let currentUser = FirebaseAuth.Auth.auth().currentUser
        
        //update username and email, even when there is no need to
        guard let edit_username = txtFieldUsername.text, !edit_username.isEmpty,
              let edit_email = txtFieldEmail.text, !edit_email.isEmpty,
              let editPW = txtFieldPW.text,
              let editPW_Confirm = txtFieldPWConfirm.text
        else {
            labelErrMsg.text = "Missing field data"
            labelErrMsg.isHidden = false
            return
        }
        
        //update email of user authetication
        if txtFieldEmail.text != userEmail
        {
            currentUser?.updateEmail(to: txtFieldEmail.text!){ error in
                if let error = error{
                    print(error)
                    self.labelErrMsg.text = "\(error)"
                    self.labelErrMsg.isHidden = false
                    return
                }
            }
        }
        
        db.collection("Accounts").document("\(uid)").updateData([
            "username": edit_username,
            "email_address": edit_email
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
                self.labelErrMsg.text = "The email address is badly formatted"
                self.labelErrMsg.isHidden = false
                return
            }
        }
        
        //update password of user authetication
        if (!editPW.isEmpty)
        {
            if (editPW == editPW_Confirm)
            {
                if (editPW.count >= 7)
                {
                    currentUser?.updatePassword(to: txtFieldPW.text!)
                    
                } else {
                    self.labelErrMsg.text = "Password must be 6 characters long or more"
                    self.labelErrMsg.isHidden = false
                    return
                }
            } else {
                self.labelErrMsg.text = "Password does not match"
                self.labelErrMsg.isHidden = false
                return
            }
        }
        //no error happened -> Good
        self.labelErrMsg.text = ""
        self.labelErrMsg.isHidden = true
        //back to Home page
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func GetHelp(_ sender: Any)
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
