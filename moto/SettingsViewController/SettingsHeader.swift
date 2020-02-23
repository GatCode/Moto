import UIKit

class SettingsHeader: UITableViewCell {
    
    var headerLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = def_settingsVCHeaderBackgroundColor
        setupHeaderLabel()
    }
    
    fileprivate func setupHeaderLabel() {
        headerLabel = UILabel()
        headerLabel.font = UIFont.systemFont(ofSize: def_settingsVCHeaderLabelFontSize, weight: .medium)
        headerLabel.textColor = def_settingsVCHeaderFontColor
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerLabel)
        headerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: def_settingsVCHeaderPaddingLR).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -def_settingsVCHeaderPaddingLR).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -def_settingsVCHeaderOffset).isActive = true
    }
}
