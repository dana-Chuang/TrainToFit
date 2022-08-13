import Foundation
import UIKit

class HelpReceivedViewController: UIViewController
{
    override func viewDidLoad()
    {
        navigationController?.isNavigationBarHidden = true
        super.viewDidLoad()
    }
    
    @IBAction func BackToHomePage(_ sender: Any)
    {
        navigationController?.isNavigationBarHidden = false
        //back to Home page
        navigationController?.popToRootViewController(animated: true)
    }
}
