import UIKit

class PlanTableViewCell: UITableViewCell {

    @IBOutlet weak var planView: UIView!
    @IBOutlet weak var planName: UILabel!
    @IBOutlet weak var planCreateDate: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
