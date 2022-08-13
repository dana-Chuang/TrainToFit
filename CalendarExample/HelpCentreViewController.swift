import Foundation
import UIKit

class HelpCentreViewController: UIViewController
{
    
    @IBOutlet weak var txtFieldHelpMsg: UITextView!
    @IBOutlet weak var labelErrMsg: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func submitDescription(_ sender: Any)
    {
        
        if (txtFieldHelpMsg.text.isEmpty)
        {
            labelErrMsg.text = "Description cannot be empty!"
            labelErrMsg.isHidden = false
            return
        }
        if let viewController = storyboard?.instantiateViewController(identifier: "help_msg_received") as? HelpReceivedViewController
        {
            navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
}
