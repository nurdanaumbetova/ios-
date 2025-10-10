import Foundation

// Product Structure
struct Product {
    let id: String
    let name: String
    let price: Double
    let category: Category
    let description: String
    
    // Категория товара
    enum Category {
        case electronics, clothing, food, books
    }
    
    // Вывод цены с символом $
    var displayPrice: String {
        return String(format: "$%.2f", price)
    }
    
    // Инициализатор (конструктор)
    init(id: String = UUID().uuidString,
         name: String,
         price: Double,
         category: Category,
         description: String) {
        // Проверяем, что цена положительная
        guard price > 0 else {
            fatalError("Price must be positive")
        }
        self.id = id
        self.name = name
        self.price = price
        self.category = category
        self.description = description
    }
}

// CartItem Structure
// CartItem — это элемент корзины (товар + количество)
struct CartItem {
    let product: Product
    private(set) var quantity: Int
    
    // Подсчёт стоимости для одного товара
    var subtotal: Double {
        return product.price * Double(quantity)
    }
    
    // Изменение количества
    mutating func updateQuantity(_ newQuantity: Int) {
        guard newQuantity > 0 else {
            print("Quantity must be greater than 0")
            return
        }
        quantity = newQuantity
    }
    
    // Увеличить количество
    mutating func increaseQuantity(by amount: Int) {
        guard amount > 0 else { return }
        quantity += amount
    }
}

// ShoppingCart Class
// ShoppingCart — это класс (используем class, потому что корзина — это reference type)
class ShoppingCart {
    private(set) var items: [CartItem] = []   // массив товаров
    var discountCode: String?                 // код скидки
    
    // Добавить товар в корзину
    func addItem(product: Product, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            var existingItem = items[index]
            existingItem.increaseQuantity(by: quantity)
            items[index] = existingItem
        } else {
            let newItem = CartItem(product: product, quantity: quantity)
            items.append(newItem)
        }
    }
    
    // Удалить товар
    func removeItem(productId: String) {
        items.removeAll { $0.product.id == productId }
    }
    
    // Обновить количество
    func updateItemQuantity(productId: String, quantity: Int) {
        guard let index = items.firstIndex(where: { $0.product.id == productId }) else { return }
        if quantity == 0 {
            removeItem(productId: productId)
        } else {
            var item = items[index]
            item.updateQuantity(quantity)
            items[index] = item
        }
    }
    
    // Очистить корзину
    func clearCart() {
        items.removeAll()
    }
    
    // Сумма всех товаров
    var subtotal: Double {
        return items.reduce(0) { $0 + $1.subtotal }
    }
    
    // Рассчитать скидку
    var discountAmount: Double {
        guard let code = discountCode else { return 0 }
        switch code {
        case "SAVE10": return subtotal * 0.10
        case "SAVE20": return subtotal * 0.20
        default: return 0
        }
    }
    
    // Общая сумма с учётом скидки
    var total: Double {
        return subtotal - discountAmount
    }
    
    // Количество товаров
    var itemCount: Int {
        return items.reduce(0) { $0 + $1.quantity }
    }
    
    // Проверяем, пустая ли корзина
    var isEmpty: Bool {
        return items.isEmpty
    }
}

// Address Structure
// Address хранит данные для доставки
struct Address {
    let street: String
    let city: String
    let zipCode: String
    let country: String
    
    var formattedAddress: String {
        return "\(street)\n\(city), \(zipCode)\n\(country)"
    }
}

// Order Structure
// Order создаётся на основе корзины
struct Order {
    let orderId: String
    let items: [CartItem]
    let subtotal: Double
    let discountAmount: Double
    let total: Double
    let timestamp: Date
    let shippingAddress: Address
    
    init(from cart: ShoppingCart, shippingAddress: Address) {
        self.orderId = UUID().uuidString
        self.items = cart.items
        self.subtotal = cart.subtotal
        self.discountAmount = cart.discountAmount
        self.total = cart.total
        self.timestamp = Date()
        self.shippingAddress = shippingAddress
    }
    
    var itemCount: Int {
        return items.reduce(0) { $0 + $1.quantity }
    }
}

// Test Scenario
print("🛒 Shopping Cart System Test Started\n")

// Создаём продукты
let laptop = Product(name: "MacBook Air", price: 1200, category: .electronics, description: "Apple laptop")
let book = Product(name: "Swift Programming", price: 45, category: .books, description: "Learn Swift language")
let headphones = Product(name: "AirPods", price: 250, category: .electronics, description: "Wireless earbuds")

// Создаём корзину
let cart = ShoppingCart()
cart.addItem(product: laptop, quantity: 1)
cart.addItem(product: book, quantity: 2)
cart.addItem(product: laptop, quantity: 1) // увеличиваем количество ноутбуков

print("Subtotal: \(cart.subtotal)")
print("Item count: \(cart.itemCount)")

cart.discountCode = "SAVE10"
print("Total with discount: \(cart.total)")

// Удаляем книгу
cart.removeItem(productId: book.id)
print("After removing book, items left: \(cart.itemCount)")

// Проверка Reference Type
func modifyCart(_ cart: ShoppingCart) {
    cart.addItem(product: headphones, quantity: 1)
}
modifyCart(cart)
print("After external modification, item count: \(cart.itemCount)")

// Проверка Value Type
var item1 = CartItem(product: laptop, quantity: 1)
var item2 = item1
item2.updateQuantity(5)
print("item1 quantity: \(item1.quantity), item2 quantity: \(item2.quantity)")

// Создание заказа
let address = Address(street: "Main Street 10", city: "Almaty", zipCode: "050000", country: "Kazakhstan")
let order = Order(from: cart, shippingAddress: address)

cart.clearCart()
print("Order items count: \(order.itemCount)")
print("Cart items count: \(cart.itemCount)")

print("\nOrder created at \(order.timestamp)")
print("Shipping to:\n\(order.shippingAddress.formattedAddress)")
