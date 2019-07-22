final class TaskCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var checkboxButton: UIButton!
    @IBOutlet private weak var taskNameLabel: UILabel!
    @IBOutlet private weak var timerButton: UIButton!
    @IBOutlet private weak var rubbishButtonWidthConstraint: NSLayoutConstraint!
    private var selectedTask: Task!
    var reloadCell: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        checkboxButton.setImage(#imageLiteral(resourceName: "ic-checked"), for: .selected)
        checkboxButton.isUserInteractionEnabled = false
    }
    func configTaskCell(_ task: Task) {
        checkboxButton.isSelected = task.isChecked
        if task.isChecked {
            taskNameLabel.attributedText = task.taskName.setStrikeThrough()
            rubbishButtonWidthConstraint.constant = 45
        } else {
            taskNameLabel.attributedText = nil
            taskNameLabel.text = task.taskName
            rubbishButtonWidthConstraint.constant = 0
        }
        if task.timer == nil {
            timerButton.isHidden = true
        } else {
            timerButton.isHidden = false
            timerButton.setTitle(task.timer?.convertTimeFormate(), for: .normal)
        }
        selectedTask = task
    }
    @IBAction func handleRubbishButtonTapped(_ sender: Any) {
        AlertMessage.showMessage(title: "Message", msg: "Are you sure to delete this task?") { result in
            if result {
                RealmService.shared.delete(self.selectedTask)
                self.reloadCell?()
            }
        }
    }
}
