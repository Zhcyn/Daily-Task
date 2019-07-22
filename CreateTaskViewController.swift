final class CreateTaskViewController: UIViewController, KeyboardHandler {
    @IBOutlet private weak var saveNoteButton: UIButton!
    @IBOutlet private weak var datetimeTextField: UITextField!
    @IBOutlet private weak var bottomSaveButtonConstraint: NSLayoutConstraint!
    @IBOutlet private weak var leadingSaveButtonConstraint: NSLayoutConstraint!
    @IBOutlet private weak var taskContentTextView: UITextView!
    @IBOutlet private weak var dateTimeView: UIView!
    @IBOutlet private weak var bottomLineView: UIView!
    @IBOutlet private weak var leadingViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var scrollView: UIScrollView!
    private var datePicker: UIDatePicker!
    private let placeHolderText: String = "Write something here..."
    private var switchIsOn: Bool = false
    private var viewModel: CreateTaskViewModel!
    var selectedGroup: Group!
    var didChangedWhenKeyboardShow: ((Bool, CGFloat) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupDatePicker()
        self.configCffFJDaily("config")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObservingKeyboardChanges()
    }
    private func config() {
        scrollView.hideKeyboard()
        startObservingKeyboardChanges()
        viewModel = CreateTaskViewModel()
        didChangedWhenKeyboardShow = { [weak self] show, changeInHeight in
            guard let self = self else { return }
            self.bottomSaveButtonConstraint.constant = show ? changeInHeight : 64
            self.leadingSaveButtonConstraint.constant = show ? 0 : 32
            self.saveNoteButton.cornerRadius = show ? 0 : 32
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear], animations: {
                self.view.layoutIfNeeded()
            })
        }
        taskContentTextView.text = placeHolderText
        taskContentTextView.textColor = UIColor.lightGray
        leadingViewConstraint.constant = !switchIsOn ? 20 : 84
        self.dateTimeView.alpha = !self.switchIsOn ? 0.0 : 1.0
        bottomLineView.alpha = !self.switchIsOn ? 0.0 : 1.0
    }
    private func setupDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .time
        datePicker.minimumDate = Date()
        datePicker?.addTarget(self, action: #selector(handleDatePickerValueChanged), for: .valueChanged)
        datetimeTextField.text = datePicker.date.convertTimeFormate()
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(dismissPicker))
        datetimeTextField.inputAccessoryView = toolBar
        datetimeTextField.inputView = datePicker
    }
    @objc
    private func dismissPicker() {
        view.endEditing(true)
    }
    @objc
    private func handleDatePickerValueChanged(_ datePicker: UIDatePicker) {
        datetimeTextField.text = datePicker.date.convertTimeFormate()
    }
    @IBAction func handleCloseButtonTapped(_ sender: Any) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func switchButtonValueChanged(_ sender: UISwitch) {
        switchIsOn = sender.isOn
        self.leadingViewConstraint.constant = !self.switchIsOn ? 20 : 84
        let animator = UIViewPropertyAnimator(duration: 0.4, curve: .linear, animations: {
            self.dateTimeView.alpha = !self.switchIsOn ? 0.0 : 1.0
            self.bottomLineView.alpha = !self.switchIsOn ? 0.0 : 1.0
            self.view.layoutIfNeeded()
        })
        animator.startAnimation()
    }
    @IBAction func handleSaveNoteButtonTapped(_ sender: UIButton) {
        guard let taskName = taskContentTextView.text else { return }
        guard taskName.removeWhitespace() != "" && taskContentTextView.textColor != .lightGray else {
            showAlert(title: "Message", message: "Please fill your task's content")
            return
        }
        if switchIsOn {
             viewModel.createTask(taskName: taskName, timer: datePicker.date, group: selectedGroup)
            NotificationManager.shared.setupLocalNotification(datePicker.date, message: taskName)
        } else {
             viewModel.createTask(taskName: taskName, timer: nil, group: selectedGroup)
        }
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}
extension CreateTaskViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView == taskContentTextView else { return }
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView == taskContentTextView else { return }
        if textView.text.isEmpty {
            textView.text = placeHolderText
            textView.textColor = .lightGray
        }
    }
}
extension CreateTaskViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == datetimeTextField {
            return false
        }
        return true
    }
}
extension CreateTaskViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
