import SwiftUI

open class SwiftUIFocusGuideDebugView: UIView {

    public var isEnabled: Bool = true {
        didSet {
            let color = isEnabled ? UIColor.green : UIColor.red
            backgroundColor = color.withAlphaComponent(0.15)
            layer.borderColor = color.withAlphaComponent(0.3).cgColor
            titleLabel.textColor = color.withAlphaComponent(0.3)
        }
    }

    public var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    private(set) public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedSystemFont(ofSize: 24, weight: .regular)
        return label
    }()

    public init() {
        super.init(frame: .zero)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        layer.borderWidth = 1

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
