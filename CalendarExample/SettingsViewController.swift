import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class SettingsViewController: UIViewController
{
    var db: Firestore!
    let uid : String = (Auth.auth().currentUser?.uid)!
    
    @IBOutlet weak var txtFieldUsername: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPW: UITextField!
    @IBOutlet weak var txtFieldPWConfirm: UITextField!
    @IBOutlet weak var labelErrMsg: UILabel!
    @IBOutlet var popupView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        db = Firestore.firestore()
        ShowUserInfo()
        
        popupView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.width * 0.5)
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
        animatIn(desiredView: popupView)
    }
    
    @IBAction func CancelDeactivation(_ sender: Any)
    {
        animateOut(desiredView: popupView)
    }
    
    @IBAction func ProceedDeactivation(_ sender: Any)
    {
        let user = Auth.auth().currentUser
        user?.delete { error in
          if let error = error {
            // An error happened.
          } else {
            // Account from Authentication section deleted.
          }
        }
        
        //now delete data from firestore database
        self.db.collection("Accounts").document("\(self.uid)").delete(){ err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        //then delete file of profile image from storage
        // Create a reference to the file to delete
        let profileImgRef = Storage.storage().reference().child("user/profileImg/\(self.uid)")
        // Delete the file
        profileImgRef.delete { error in
          if let error = error {
            // Uh-oh, an error occurred!
          } else {
            // File deleted successfully
          }
        }
        
        //back to login page
        self.dismiss(animated: true, completion: nil)
    }
    
    func animatIn(desiredView: UIView)
    {
        let backgroundView = self.view!
        //attach the desired view to the screen
        backgroundView.addSubview(desiredView)
        //set the view's scaling to be 120%
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundView.center
        
        //animate the effect
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
        })
    }
    
    func animateOut(desiredView: UIView)
    {
        UIView.animate(withDuration: 0.3,animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        }, completion: { _ in
            desiredView.removeFromSuperview()
            
        })
    }
}
