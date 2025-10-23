import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityDescriptionLabel: UILabel!    // <-- new Outlet

    // Array of tuples: (Name, imageName, description)
    let cities: [(name: String, image: String, description: String)] = [
        ("Paris", "paris", "The city of love and romance. Home to the Eiffel Tower and cozy cafes."),
        ("London", "london", "Historic city of Big Ben, beautiful bridges, and world-class museums."),
        ("Dubai", "dubai", "A modern desert metropolis with skyscrapers, luxury, and innovation."),
        ("New York", "newyork", "The city that never sleeps — skyscrapers, Broadway, and endless energy."),
        ("Tokyo", "tokyo", "A perfect blend of tradition and technology, neon lights, and ancient temples."),
        ("Seoul", "seoul", "A vibrant capital of Korea — street food, pop culture, and modern lifestyle."),
        ("Rome", "rome", "The cradle of ancient history — Colosseum, forums, and charming piazzas."),
        ("Almaty", "almaty", "A mountain city in Kazakhstan surrounded by stunning nature and culture."),
        ("Istanbul", "istanbul", "Where Europe meets Asia — beautiful mosques, bazaars, and rich history."),
        ("Sydney", "sydney", "A sunny harbor city famous for its Opera House and golden beaches.")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initial styling
        cityImageView.contentMode = .scaleAspectFill
        cityImageView.clipsToBounds = true
        cityImageView.layer.cornerRadius = 16

        cityLabel.font = UIFont.boldSystemFont(ofSize: 28)
        cityLabel.textColor = .white
        cityLabel.shadowColor = UIColor.black.withAlphaComponent(0.6)
        cityLabel.shadowOffset = CGSize(width: 1, height: 1)

        cityDescriptionLabel.font = UIFont.systemFont(ofSize: 16)
        cityDescriptionLabel.textColor = UIColor.white.withAlphaComponent(0.95)
        cityDescriptionLabel.numberOfLines = 0
        cityDescriptionLabel.textAlignment = .center
        
       
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background") // имя из Assets
        backgroundImage.contentMode = .scaleAspectFill

        // Show the first city by default
        updateCity(at: 0)
        
        self.view.insertSubview(backgroundImage, at: 0)
        
    }
    
    

    func updateCity(at index: Int) {
        guard index >= 0 && index < cities.count else { return }
        let city = cities[index]
        cityLabel.text = city.name
        cityDescriptionLabel.text = city.description
        cityImageView.image = UIImage(named: city.image)
    }

    @IBAction func randomizeButtonPressed(_ sender: UIButton) {
        let randomIndex = Int.random(in: 0..<cities.count)

        // Simple image transition animation
        UIView.transition(with: cityImageView, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.cityImageView.image = UIImage(named: self.cities[randomIndex].image)
        }, completion: nil)

        // Smooth label animations
        UIView.transition(with: cityLabel, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.cityLabel.text = self.cities[randomIndex].name
        }, completion: nil)

        UIView.transition(with: cityDescriptionLabel, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.cityDescriptionLabel.text = self.cities[randomIndex].description
        }, completion: nil)
    }
}
