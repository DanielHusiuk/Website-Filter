//
//  ViewController.swift
//  Website Filter
//
//  Created by Daniel Husiuk on 29.09.2026.
//

import UIKit
import WebKit

final class ViewController: UIViewController {
    
    private let verticalStack = UIStackView()
    private let horizontalStack = UIStackView()
    
    private let statusBarBackground = BlurBackgroundView()
    private let toolBarBackground = BlurBackgroundView()
    private let textField = CustomTextField()
    private let button = CustomButton()
    private let activityIndicator = CustomIndicatorView(style: .medium)
    
    private let buttonModel = ButtonModel()
    private var allButtons: [ButtonType: CustomButton] = [:]
    
    private var webView: WKWebView = .init()
    private let filterStore: FilterStoreProtocol = FilterStore()
    private let filterRule = FilterRule()
    private var hasWebsite = false
    
    private lazy var filterListNavigationController: UINavigationController = {
        let listViewController = FilterListViewController(filterStore: filterStore)
        listViewController.onFiltersChanged = { [weak self] in
            self?.updateButtonState()
        }
        return UINavigationController(rootViewController: listViewController)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebKitView()
        setupToolBarLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateWebKitViewInsets()
    }
    
    private func setupToolBarLayout() {
        setupStatusBar()
        setupToolBarBackground()
        setupVerticalStack()
        
        setupTextField()
        setupActivityIndicator()
        setupHorizontalStack()
        setupButtons()
    }
    
    // MARK: - WebView Layout Setup
    
    private func setupWebKitView() {
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.scrollView.keyboardDismissMode = .interactive
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        view.insertSubview(webView, at: 0)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func updateWebKitViewInsets() {
        let insets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: toolBarBackground.bounds.height,
            right: 0
        )
        webView.scrollView.contentInset = insets
        webView.scrollView.verticalScrollIndicatorInsets = insets
    }

    private func setupStatusBar() {
        statusBarBackground.clipsToBounds = false
        view.addSubview(statusBarBackground)
        
        NSLayoutConstraint.activate([
            statusBarBackground.topAnchor.constraint(equalTo: view.topAnchor),
            statusBarBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBarBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBarBackground.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    // MARK: - WebView Actions
    
    private func loadWebsite(_ urlString: String) {
        guard let url = makeURL(from: urlString) else { return }
        guard !filterStore.isBlocked(url) else {
            showBlockedAlert()
            return
        }
        hasWebsite = true
        webView.isHidden = false
        webView.load(URLRequest(url: url))
    }
    
    private func makeURL(from string: String) -> URL? {
        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedString.isEmpty else { return nil }
        
        if trimmedString.hasPrefix("http://") || trimmedString.hasPrefix("https://") {
            return URL(string: trimmedString)
        }
        return URL(string: "https://\(trimmedString)")
    }
    
    private func updateTextFieldURL() {
        textField.text = webView.url?.absoluteString ?? ""
    }
    
    // MARK: - Toolbar Layout Setup
    
    private func setupToolBarBackground() {
        toolBarBackground.clipsToBounds = false
        view.addSubview(toolBarBackground)
        
        NSLayoutConstraint.activate([
            toolBarBackground.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            toolBarBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBarBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolBarBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupVerticalStack() {
        verticalStack.axis = .vertical
        verticalStack.alignment = .fill
        verticalStack.spacing = 10
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.clipsToBounds = false
        toolBarBackground.addSubview(verticalStack)
        
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: toolBarBackground.topAnchor, constant: 10),
            verticalStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10)
        ])
    }
    
    private func setupTextField() {
        let textFieldBackgroundView = UIView()
        textFieldBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        textFieldBackgroundView.clipsToBounds = false
        textFieldBackgroundView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        textField.delegate = self
        textFieldBackgroundView.addSubview(textField)
        verticalStack.addArrangedSubview(textFieldBackgroundView)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: textFieldBackgroundView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: textFieldBackgroundView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: textFieldBackgroundView.trailingAnchor, constant: -16),
            textField.bottomAnchor.constraint(equalTo: textFieldBackgroundView.bottomAnchor)
        ])
    }
    
    private func setupHorizontalStack() {
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .fill
        horizontalStack.distribution = .fillEqually
        horizontalStack.spacing = 10
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        verticalStack.addArrangedSubview(horizontalStack)
        horizontalStack.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
    
    private func setupActivityIndicator() {
        textField.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -14)
        ])
    }
    
    // MARK: - Button Setup
    
    private func setupButtons() {
        for button in buttonModel.toolBarButtons {
            let toolBarButton = CustomButton(type: .system)
            
            toolBarButton.setImage(button.image, for: .normal)
            toolBarButton.setImage(button.secondaryImage, for: .selected)
            toolBarButton.accessibilityIdentifier = button.accessibilityIdentifier
            
            toolBarButton.addAction(
                UIAction { [weak self] _ in
                    self?.handleButtonAction(button.type)
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                },
                for: .touchUpInside
            )
            allButtons[button.type] = toolBarButton
            horizontalStack.addArrangedSubview(toolBarButton)
        }
        updateButtonState()
    }
    
    private func handleButtonAction(_ type: ButtonType) {
        switch type {
        case .back:
            if webView.canGoBack {
                webView.goBack()
            } else {
                showHomePage()
            }
        case .forward:
            if webView.canGoForward {
                webView.goForward()
            }
        case .share:
            shareButtonTapped()
        case .filter:
            showFilterButtonAlert()
        case .filterList:
            present(filterListNavigationController, animated: true)
        }
    }
    
    private func updateButtonState() {
        allButtons[.back]?.isEnabled = hasWebsite
        allButtons[.forward]?.isEnabled = hasWebsite && webView.canGoForward
        allButtons[.share]?.isEnabled = hasWebsite
        updateFilterButtonImage()
        allButtons[.filterList]?.isEnabled = !filterStore.isEmpty
    }
    
    private func updateFilterButtonImage() {
        guard let model = buttonModel.toolBarButtons.first(where: { $0.type == .filter }) else { return }
        let image = filterStore.isEmpty ? model.image : (model.secondaryImage ?? model.image)
        allButtons[.filter]?.setImage(image, for: .normal)
    }
    
    // MARK: - Button Actions
    
    private func showHomePage() {
        webView.stopLoading()
        activityIndicator.stopAnimating()
        webView.isHidden = true
        textField.text = ""
        hasWebsite = false
        updateButtonState()
    }
    
    private func shareButtonTapped() {
        guard let message = webView.url?.absoluteString else { return }
        
        let activityViewController = UIActivityViewController(
            activityItems: [message],
            applicationActivities: nil
        )
        
        activityViewController.popoverPresentationController?.sourceView = view
        activityViewController.popoverPresentationController?.sourceRect = view.bounds
        present(activityViewController, animated: true)
    }
    
    private func showFilterButtonAlert() {
        let alert = UIAlertController(
            title: "Add new website filter",
            message: """
            Add words to ignore when opening website links
            
            (Hint: At least 2 characters, no spaces)
            """,
            preferredStyle: .alert
        )
        
        let addFilterAction = UIAlertAction(
            title: "Add",
            style: .default
        ) { [weak self, weak alert] _ in
            self?.addNewFilter(alert?.textFields?.first?.text ?? "")
        }
        addFilterAction.isEnabled = false
        
        let rule = filterRule
        alert.addTextField { field in
            field.placeholder = "Type here"
            field.keyboardType = .webSearch
            field.addAction(UIAction { [weak field, weak addFilterAction] _ in
                addFilterAction?.isEnabled = rule.validate(field?.text ?? "").isValid
            }, for: .editingChanged)
        }
        
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
        ))
        alert.addAction(addFilterAction)
        present(alert, animated: true)
    }
    
    private func addNewFilter(_ text: String) {
        guard filterStore.add(text) else { return }
        updateButtonState()
        
        if let url = webView.url, filterStore.isBlocked(url) {
            showHomePage()
            showBlockedAlert()
        } else {
            webView.reload()
        }
    }
    
    private func showBlockedAlert() {
        let alert = UIAlertController(
            title: "Blocked",
            message: "This website matches one of your filters.\nAccess is restricted",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: .default,
            handler: nil
        ))
        present(alert, animated: true)
    }
}

// MARK: - Extensions

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        loadWebsite(text)
        textField.resignFirstResponder()
        return true
    }
}

extension ViewController: WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        didStartProvisionalNavigation navigation: WKNavigation!
    ) {
        activityIndicator.startAnimating()
        updateButtonState()
    }
    
    func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation!
    ) {
        activityIndicator.stopAnimating()
        updateTextFieldURL()
        updateButtonState()
    }
    
    func webView(
        _ webView: WKWebView,
        didCommit navigation: WKNavigation!
    ) {
        updateTextFieldURL()
    }
    
    func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation!,
        withError error: any Error
    ) {
        activityIndicator.stopAnimating()
        updateButtonState()
    }
    
    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: any Error
    ) {
        activityIndicator.stopAnimating()
        updateButtonState()
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void
    ) {
        let isMainFrame = navigationAction.targetFrame?.isMainFrame ?? true
        if isMainFrame,
            let url = navigationAction.request.url,
            filterStore.isBlocked(url) {
            decisionHandler(.cancel)
            showBlockedAlert()
            return
        }
        decisionHandler(.allow)
    }
}
