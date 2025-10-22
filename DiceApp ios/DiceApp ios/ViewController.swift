import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var leftDiceImageView: UIImageView!
    @IBOutlet weak var rightDiceImageView: UIImageView!

    // Массив имён изображений в Assets
    let diceImageNames = ["dice1", "dice2", "dice3", "dice4", "dice5", "dice6"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Установим начальные изображения
        leftDiceImageView.image = UIImage(named: "dice1")
        rightDiceImageView.image = UIImage(named: "dice1")

        // Настройка режима отображения
        leftDiceImageView.contentMode = .scaleAspectFit
        rightDiceImageView.contentMode = .scaleAspectFit
    }

    // Действие кнопки Roll — сюда нужно переместить логику броска
    @IBAction func rollButtonPressed(_ sender: Any) {
        // выбираем случайные индексы 0...5
        let leftIndex = Int.random(in: 0..<6)
        let rightIndex = Int.random(in: 0..<6)

    
        // обновляем изображения
        leftDiceImageView.image = UIImage(named: diceImageNames[leftIndex])
        rightDiceImageView.image = UIImage(named: diceImageNames[rightIndex])
    }
}
