import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private var isEditMode = true
    private var showSheet = false
    private var status: ExportStatus = .idle
    private var exportFormat: ExportFormat = .docx
    
    private var content = "# 移动端适配进展\n\n1. 支持 DOCX/PDF/图片 导出\n2. 增加全局水印配置\n3. 优化转换交互逻辑\n\n```mermaid\ngraph LR\nMD --> DOCX\nMD --> PDF\nMD --> IMAGE\n```"
    
    private var config = Config(
        fontSize: 14,
        theme: "Standard",
        numbering: true,
        watermark: WatermarkConfig(
            enabled: false,
            text: "Md2Doc Internal",
            opacity: 0.2
        )
    )
    
    // MARK: - UI Elements
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var logoView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "Md"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "产品需求文档"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Md2Doc"
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var modeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Preview", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleMode), for: .touchUpInside)
        return button
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        view.layer.shadowOpacity = 0.03
        view.layer.shadowRadius = 40
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = content
        textView.font = UIFont.systemFont(ofSize: CGFloat(config.fontSize))
        textView.textColor = .black
        textView.backgroundColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        return textView
    }()
    
    private lazy var previewView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isHidden = true
        
        let titleLabel = UILabel()
        titleLabel.text = "移动端适配进展"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textAlignment = .left
        
        let listStackView = UIStackView()
        listStackView.axis = .vertical
        listStackView.spacing = 16
        
        let item1 = UILabel()
        item1.text = "• 支持 DOCX/PDF/图片 导出"
        item1.font = UIFont.systemFont(ofSize: 16)
        
        let item2 = UILabel()
        item2.text = "• 增加全局水印配置"
        item2.font = UIFont.systemFont(ofSize: 16)
        
        let item3 = UILabel()
        item3.text = "• 优化转换交互逻辑"
        item3.font = UIFont.systemFont(ofSize: 16)
        
        listStackView.addArrangedSubview(item1)
        listStackView.addArrangedSubview(item2)
        listStackView.addArrangedSubview(item3)
        
        let mermaidView = UIView()
        mermaidView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        mermaidView.layer.cornerRadius = 16
        mermaidView.layer.borderWidth = 2
        mermaidView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        mermaidView.translatesAutoresizingMaskIntoConstraints = false
        
        let playIcon = UIImageView()
        playIcon.image = UIImage(systemName: "play.circle")
        playIcon.tintColor = .lightGray
        playIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let mermaidLabel = UILabel()
        mermaidLabel.text = "Mermaid Engine"
        mermaidLabel.font = UIFont.boldSystemFont(ofSize: 12)
        mermaidLabel.textColor = .lightGray
        mermaidLabel.translatesAutoresizingMaskIntoConstraints = false
        
        mermaidView.addSubview(playIcon)
        mermaidView.addSubview(mermaidLabel)
        
        NSLayoutConstraint.activate([
            playIcon.centerXAnchor.constraint(equalTo: mermaidView.centerXAnchor),
            playIcon.centerYAnchor.constraint(equalTo: mermaidView.centerYAnchor, constant: -10),
            playIcon.widthAnchor.constraint(equalToConstant: 48),
            playIcon.heightAnchor.constraint(equalToConstant: 48),
            
            mermaidLabel.topAnchor.constraint(equalTo: playIcon.bottomAnchor, constant: 10),
            mermaidLabel.centerXAnchor.constraint(equalTo: mermaidView.centerXAnchor)
        ])
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(listStackView)
        stackView.addArrangedSubview(mermaidView)
        
        NSLayoutConstraint.activate([
            mermaidView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        return stackView
    }()
    
    private lazy var toolbarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.1).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let typeButton = UIButton(type: .system)
        typeButton.setImage(UIImage(systemName: "textformat"), for: .normal)
        typeButton.tintColor = .lightGray
        typeButton.translatesAutoresizingMaskIntoConstraints = false
        
        let layersButton = UIButton(type: .system)
        layersButton.setImage(UIImage(systemName: "layers"), for: .normal)
        layersButton.tintColor = .lightGray
        layersButton.translatesAutoresizingMaskIntoConstraints = false
        
        let plusButton = UIButton(type: .system)
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.tintColor = .lightGray
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        let settingsButton = UIButton(type: .system)
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.setTitleColor(.gray, for: .normal)
        settingsButton.setImage(UIImage(systemName: "gear"), for: .normal)
        settingsButton.tintColor = .gray
        settingsButton.semanticContentAttribute = .forceRightToLeft
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        
        view.addSubview(typeButton)
        view.addSubview(layersButton)
        view.addSubview(plusButton)
        view.addSubview(settingsButton)
        
        NSLayoutConstraint.activate([
            typeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            typeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            layersButton.leadingAnchor.constraint(equalTo: typeButton.trailingAnchor, constant: 24),
            layersButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            plusButton.leadingAnchor.constraint(equalTo: layersButton.trailingAnchor, constant: 24),
            plusButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            settingsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()
    
    private lazy var formatSelectorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let docxButton = createFormatButton(title: "DOCX", isActive: exportFormat == .docx)
        let pdfButton = createFormatButton(title: "PDF", isActive: exportFormat == .pdf)
        let imageButton = createFormatButton(title: "IMAGE", isActive: exportFormat == .image)
        
        let stackView = UIStackView(arrangedSubviews: [docxButton, pdfButton, imageButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4)
        ])
        
        return view
    }()
    
    private lazy var exportButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.layer.cornerRadius = 32
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Export DOCX", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleExport), for: .touchUpInside)
        return button
    }()
    
    private lazy var settingsSheet: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        let handleView = UIView()
        handleView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        handleView.layer.cornerRadius = 3
        handleView.translatesAutoresizingMaskIntoConstraints = false
        
        let typographyCard = createSettingsCard(title: "Typography")
        let fontSizeLabel = UILabel()
        fontSizeLabel.text = "正文字号"
        fontSizeLabel.font = UIFont.boldSystemFont(ofSize: 16)
        fontSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let fontSizeValue = UILabel()
        fontSizeValue.text = "\(config.fontSize)"
        fontSizeValue.font = UIFont.boldSystemFont(ofSize: 24)
        fontSizeValue.translatesAutoresizingMaskIntoConstraints = false
        
        let fontSizeSlider = UISlider()
        fontSizeSlider.minimumValue = 12
        fontSizeSlider.maximumValue = 18
        fontSizeSlider.value = Float(config.fontSize)
        fontSizeSlider.translatesAutoresizingMaskIntoConstraints = false
        fontSizeSlider.addTarget(self, action: #selector(fontSizeChanged(_:)), for: .valueChanged)
        
        typographyCard.addSubview(fontSizeLabel)
        typographyCard.addSubview(fontSizeValue)
        typographyCard.addSubview(fontSizeSlider)
        
        NSLayoutConstraint.activate([
            fontSizeLabel.leadingAnchor.constraint(equalTo: typographyCard.leadingAnchor, constant: 24),
            fontSizeLabel.topAnchor.constraint(equalTo: typographyCard.topAnchor, constant: 24),
            
            fontSizeValue.trailingAnchor.constraint(equalTo: typographyCard.trailingAnchor, constant: -24),
            fontSizeValue.centerYAnchor.constraint(equalTo: fontSizeLabel.centerYAnchor),
            
            fontSizeSlider.leadingAnchor.constraint(equalTo: typographyCard.leadingAnchor, constant: 24),
            fontSizeSlider.trailingAnchor.constraint(equalTo: typographyCard.trailingAnchor, constant: -24),
            fontSizeSlider.topAnchor.constraint(equalTo: fontSizeLabel.bottomAnchor, constant: 16),
            fontSizeSlider.bottomAnchor.constraint(equalTo: typographyCard.bottomAnchor, constant: -24)
        ])
        
        let watermarkCard = createSettingsCard(title: "Watermark")
        let watermarkToggle = UISwitch()
        watermarkToggle.isOn = config.watermark.enabled
        watermarkToggle.translatesAutoresizingMaskIntoConstraints = false
        watermarkToggle.addTarget(self, action: #selector(watermarkToggleChanged(_:)), for: .valueChanged)
        
        let watermarkContent = UIView()
        watermarkContent.translatesAutoresizingMaskIntoConstraints = false
        
        let watermarkLabel = UILabel()
        watermarkLabel.text = "内容"
        watermarkLabel.font = UIFont.boldSystemFont(ofSize: 12)
        watermarkLabel.textColor = .gray
        watermarkLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let watermarkTextField = UITextField()
        watermarkTextField.text = config.watermark.text
        watermarkTextField.placeholder = "输入水印文字..."
        watermarkTextField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        watermarkTextField.layer.cornerRadius = 12
        watermarkTextField.paddingLeft = 16
        watermarkTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let opacityLabel = UILabel()
        opacityLabel.text = "透明度"
        opacityLabel.font = UIFont.boldSystemFont(ofSize: 12)
        opacityLabel.textColor = .gray
        opacityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let opacitySlider = UISlider()
        opacitySlider.minimumValue = 0.05
        opacitySlider.maximumValue = 0.5
        opacitySlider.value = Float(config.watermark.opacity)
        opacitySlider.translatesAutoresizingMaskIntoConstraints = false
        opacitySlider.addTarget(self, action: #selector(opacityChanged(_:)), for: .valueChanged)
        
        watermarkContent.addSubview(watermarkLabel)
        watermarkContent.addSubview(watermarkTextField)
        watermarkContent.addSubview(opacityLabel)
        watermarkContent.addSubview(opacitySlider)
        
        NSLayoutConstraint.activate([
            watermarkLabel.leadingAnchor.constraint(equalTo: watermarkContent.leadingAnchor),
            watermarkLabel.topAnchor.constraint(equalTo: watermarkContent.topAnchor),
            
            watermarkTextField.leadingAnchor.constraint(equalTo: watermarkContent.leadingAnchor),
            watermarkTextField.trailingAnchor.constraint(equalTo: watermarkContent.trailingAnchor),
            watermarkTextField.topAnchor.constraint(equalTo: watermarkLabel.bottomAnchor, constant: 8),
            watermarkTextField.heightAnchor.constraint(equalToConstant: 44),
            
            opacityLabel.leadingAnchor.constraint(equalTo: watermarkContent.leadingAnchor),
            opacityLabel.topAnchor.constraint(equalTo: watermarkTextField.bottomAnchor, constant: 16),
            
            opacitySlider.leadingAnchor.constraint(equalTo: watermarkContent.leadingAnchor),
            opacitySlider.trailingAnchor.constraint(equalTo: watermarkContent.trailingAnchor),
            opacitySlider.topAnchor.constraint(equalTo: opacityLabel.bottomAnchor, constant: 8),
            opacitySlider.bottomAnchor.constraint(equalTo: watermarkContent.bottomAnchor)
        ])
        
        watermarkContent.isHidden = !config.watermark.enabled
        
        let applyButton = UIButton(type: .system)
        applyButton.setTitle("Apply Settings", for: .normal)
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.backgroundColor = .black
        applyButton.layer.cornerRadius = 16
        applyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        applyButton.addTarget(self, action: #selector(applySettings), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [handleView, typographyCard, watermarkCard, watermarkContent, applyButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            handleView.widthAnchor.constraint(equalToConstant: 64),
            handleView.heightAnchor.constraint(equalToConstant: 6),
            handleView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            
            typographyCard.heightAnchor.constraint(equalToConstant: 120),
            watermarkCard.heightAnchor.constraint(equalToConstant: 80),
            watermarkContent.heightAnchor.constraint(equalToConstant: 160),
            applyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        return view
    }()
    
    private lazy var sheetBackdrop: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideSettings))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 1.0)
        
        view.addSubview(headerView)
        view.addSubview(cardView)
        view.addSubview(formatSelectorView)
        view.addSubview(exportButton)
        view.addSubview(sheetBackdrop)
        view.addSubview(settingsSheet)
        
        headerView.addSubview(logoView)
        headerView.addSubview(subtitleLabel)
        headerView.addSubview(titleLabel)
        headerView.addSubview(modeButton)
        headerView.addSubview(moreButton)
        
        cardView.addSubview(textView)
        cardView.addSubview(previewView)
        cardView.addSubview(toolbarView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Header View
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 88),
            
            // Logo View
            logoView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),
            logoView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            logoView.widthAnchor.constraint(equalToConstant: 32),
            logoView.heightAnchor.constraint(equalToConstant: 32),
            
            // Subtitle Label
            subtitleLabel.leadingAnchor.constraint(equalTo: logoView.trailingAnchor, constant: 8),
            subtitleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 24),
            
            // Title Label
            titleLabel.leadingAnchor.constraint(equalTo: logoView.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 4),
            
            // Mode Button
            modeButton.trailingAnchor.constraint(equalTo: moreButton.leadingAnchor, constant: -12),
            modeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            modeButton.widthAnchor.constraint(equalToConstant: 80),
            modeButton.heightAnchor.constraint(equalToConstant: 40),
            
            // More Button
            moreButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -24),
            moreButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            moreButton.widthAnchor.constraint(equalToConstant: 40),
            moreButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Card View
            cardView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: formatSelectorView.topAnchor, constant: -16),
            
            // Text View
            textView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            textView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            textView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            textView.bottomAnchor.constraint(equalTo: toolbarView.topAnchor),
            
            // Preview View
            previewView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            previewView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            previewView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            previewView.bottomAnchor.constraint(equalTo: toolbarView.topAnchor),
            
            // Toolbar View
            toolbarView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            toolbarView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            toolbarView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            toolbarView.heightAnchor.constraint(equalToConstant: 64),
            
            // Format Selector View
            formatSelectorView.bottomAnchor.constraint(equalTo: exportButton.topAnchor, constant: -16),
            formatSelectorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            formatSelectorView.heightAnchor.constraint(equalToConstant: 40),
            formatSelectorView.widthAnchor.constraint(equalToConstant: 200),
            
            // Export Button
            exportButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            exportButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exportButton.heightAnchor.constraint(equalToConstant: 64),
            exportButton.widthAnchor.constraint(equalToConstant: 224),
            
            // Sheet Backdrop
            sheetBackdrop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetBackdrop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetBackdrop.topAnchor.constraint(equalTo: view.topAnchor),
            sheetBackdrop.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Settings Sheet
            settingsSheet.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsSheet.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsSheet.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            settingsSheet.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
        ])
    }
    
    // MARK: - Helper Methods
    
    private func createFormatButton(title: String, isActive: Bool) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(isActive ? .black : .gray, for: .normal)
        button.backgroundColor = isActive ? .white : UIColor.clear
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(formatButtonTapped(_:)), for: .touchUpInside)
        button.tag = title == "DOCX" ? 0 : title == "PDF" ? 1 : 2
        return button
    }
    
    private func createSettingsCard(title: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 24)
        ])
        
        return view
    }
    
    private func updateExportButton() {
        switch status {
        case .idle:
            exportButton.setTitle("Export \(exportFormat.rawValue)", for: .normal)
            exportButton.backgroundColor = .black
        case .processing:
            exportButton.setTitle("", for: .normal)
            exportButton.backgroundColor = .black
        case .success:
            exportButton.setTitle("Saved to Files", for: .normal)
            exportButton.backgroundColor = UIColor(red: 0.2, green: 0.78, blue: 0.35, alpha: 1.0)
        }
    }
    
    // MARK: - Actions
    
    @objc private func toggleMode() {
        isEditMode.toggle()
        textView.isHidden = !isEditMode
        previewView.isHidden = isEditMode
        modeButton.setTitle(isEditMode ? "Preview" : "Edit", for: .normal)
        modeButton.setTitleColor(isEditMode ? .gray : .white, for: .normal)
        modeButton.backgroundColor = isEditMode ? UIColor.lightGray.withAlphaComponent(0.2) : UIColor(red: 0.15, green: 0.39, blue: 0.92, alpha: 1.0)
    }
    
    @objc private func showSettings() {
        showSheet = true
        sheetBackdrop.isHidden = false
        settingsSheet.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.sheetBackdrop.alpha = 1
            self.settingsSheet.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    @objc private func hideSettings() {
        showSheet = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.sheetBackdrop.alpha = 0
            self.settingsSheet.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        }) { _ in
            self.sheetBackdrop.isHidden = true
            self.settingsSheet.isHidden = true
        }
    }
    
    @objc private func applySettings() {
        hideSettings()
        textView.font = UIFont.systemFont(ofSize: CGFloat(config.fontSize))
    }
    
    @objc private func formatButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            exportFormat = .docx
        case 1:
            exportFormat = .pdf
        case 2:
            exportFormat = .image
        default:
            break
        }
        updateExportButton()
    }
    
    @objc private func handleExport() {
        status = .processing
        updateExportButton()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            self.status = .success
            self.updateExportButton()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.status = .idle
                self.updateExportButton()
            }
        }
    }
    
    @objc private func fontSizeChanged(_ sender: UISlider) {
        config.fontSize = Int(sender.value)
    }
    
    @objc private func watermarkToggleChanged(_ sender: UISwitch) {
        config.watermark.enabled = sender.isOn
        // Update UI for watermark settings
    }
    
    @objc private func opacityChanged(_ sender: UISlider) {
        config.watermark.opacity = Double(sender.value)
    }
}

// MARK: - UITextViewDelegate

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        content = textView.text
    }
}

// MARK: - Extensions

extension UITextField {
    var paddingLeft: CGFloat {
        get {
            return leftView?.frame.size.width ?? 0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
}

// MARK: - Models

enum ExportStatus {
    case idle
    case processing
    case success
}

enum ExportFormat: String {
    case docx = "DOCX"
    case pdf = "PDF"
    case image = "IMAGE"
}

struct WatermarkConfig {
    var enabled: Bool
    var text: String
    var opacity: Double
}

struct Config {
    var fontSize: Int
    var theme: String
    var numbering: Bool
    var watermark: WatermarkConfig
}
