//
//  DictTableViewCell.swift
//  FareCodeDocPicker
//
//  Created by  Robin George  on 11/12/21.
//

import UIKit

class DictTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func cellConfig(directoryContents:String){
        self.textLabel?.text = directoryContents
    }
}
