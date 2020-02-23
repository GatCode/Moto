import UIKit

class SettingsCell: UITableViewCell {
    
    var settingsLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupBasicCell()
        setupSettingsLabel()
    }
    
    fileprivate func setupBasicCell() {
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets(top: 0, left: def_settingsVCCellPaddingLR, bottom: 0, right: def_settingsVCCellPaddingLR)
        self.backgroundColor = def_settingsVCBackgroundColor
    }
    
    fileprivate func setupSettingsLabel() {
        settingsLabel = UILabel()
        settingsLabel.font = UIFont.systemFont(ofSize: def_settingsVCCellLabelFontSize, weight: .regular)
        settingsLabel.textColor = def_settingsVCCellLabelFontColor
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(settingsLabel)
        settingsLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: def_settingsVCCellPaddingLR).isActive = true
        settingsLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -def_settingsVCCellPaddingLR).isActive = true
        settingsLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
