import MessageUI
final class SettingsViewController: UIViewController {
    @IBOutlet private weak var dateTodayLabel: UILabel!
    private let appId: String = "1473763129"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewDidLoadLXAIhDaily("dall")
    }
    @IBAction func handleCloseButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func handleSendFeedbackButtonTapped(_ sender: Any) {
        sendEmail()
    }
    @IBAction func handleRateButtonTapped(_ sender: Any) {
        let iOSAppStoreURI: String = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=" + appId
        guard let url = URL(string: iOSAppStoreURI) else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func handleShareButtonTapped(_ sender: Any) {
        shareToFriends()
    }
}
extension SettingsViewController {
    private func shareToFriends() {
        let appLink: String = "https://itunes.apple.com/app/id" + appId + "?mt=8"
        let message = "Try this app: " + appLink
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityController.completionWithItemsHandler = { [unowned self] (activity, success, items, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityController, animated: true, completion: nil)
    }
}
extension SettingsViewController: MFMailComposeViewControllerDelegate {
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["jsonkeny@gmail.com"])
            present(mail, animated: true)
        } else {
            showAlert(title: "Error", message: ErrorMessages.cannotSendEmail.rawValue)
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        switch result {
        case .sent:
            showAlert(title: "Message", message: ErrorMessages.sendEmailSuccess.rawValue)
        case .failed:
            showAlert(title: "Error", message: error?.localizedDescription ?? ErrorMessages.sendEmailFail.rawValue)
        default:
            break
        }
    }
}
extension SettingsViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
