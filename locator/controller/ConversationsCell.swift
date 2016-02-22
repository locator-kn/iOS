
import UIKit

class ConversationsCell: UITableViewCell {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var messageTeaser: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
