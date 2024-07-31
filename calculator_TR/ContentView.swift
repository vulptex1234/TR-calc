import SwiftUI

struct ContentView: View {
    @State private var items_food = [
        OrderItem(name: "月", price: 12540),
        OrderItem(name: "陽", price: 9900),
        OrderItem(name: "風", price: 8580),
        OrderItem(name: "空", price: 6600),
        OrderItem(name: "ゆり", price: 2640),
        OrderItem(name: "もも", price: 1980),
        OrderItem(name: "供養膳", price: 3300),
    ]
    
    @State private var items_drink = [
        OrderItem(name: "ビール", price: 730),
        OrderItem(name: "日本酒", price: 470),
        OrderItem(name: "ノンアルコールビール", price: 510),
        OrderItem(name: "ウーロン茶", price: 270),
        OrderItem(name: "オレンジジュース", price: 270),
        OrderItem(name: "コーラ", price: 270),
        OrderItem(name: "ジンジャーエール", price: 270),
        OrderItem(name: "白桃ジュース", price: 530),
        OrderItem(name: "三ヶ日ジュース", price: 530),
        OrderItem(name: "ミネラルウォーター", price: 200),
    ]

    var totalAmountFood: Int {
        items_food.reduce(0) { $0 + $1.totalPrice }
    }

    var totalAmountDrink: Int {
        items_drink.reduce(0) { $0 + $1.totalPrice }
    }

    var totalAmount: Int {
        totalAmountFood + totalAmountDrink
    }

    var selectedItems: [OrderItem] {
        (items_food + items_drink).filter { $0.quantity > 0 }
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("料理")) {
                        ForEach($items_food) { $item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .fontWeight(.semibold)
                                    Text("[\(item.price)円]")
                                }
                                Spacer()
                                Picker("", selection: $item.quantity) {
                                    ForEach(0..<51) { i in
                                        Text("\(i)").tag(i)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(width: 60)
                                Text("\(item.totalPrice)円")
                                    .frame(width: 100, alignment: .trailing)
                            }
                            .background(item.quantity > 0 ? Color.yellow.opacity(0.2) : Color.clear)
                        }
                    }
                    
                    Section(header: Text("ドリンク")) {
                        ForEach($items_drink) { $item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .fontWeight(.semibold)
                                    Text("[\(item.price)円]")
                                }
                                Spacer()
                                Picker("", selection: $item.quantity) {
                                    ForEach(0..<51) { i in
                                        Text("\(i)").tag(i)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(width: 60)
                                Text("\(item.totalPrice)円")
                                    .frame(width: 100, alignment: .trailing)
                            }
                            .background(item.quantity > 0 ? Color.yellow.opacity(0.2) : Color.clear)
                        }
                    }
                }
                
                VStack {
                    HStack {
                        Text("料理合計 :")
                        Spacer()
                        Text("\(totalAmountFood)円")
                    }
                    .frame(maxHeight: 10)
                    .padding()
                    .font(.title3)
                    
                    HStack {
                        Text("ドリンク合計 :")
                        Spacer()
                        Text("\(totalAmountDrink)円")
                    }
                    .frame(maxHeight: 10)
                    .padding()
                    .font(.title3)
                    
                    HStack {
                        Text("合計金額 :")
                        Spacer()
                        Text("\(totalAmount)円")
                    }
                    .fontWeight(.semibold)
                    .frame(maxHeight: 10)
                    .padding()
                    .font(.title)
                }
                
                HStack {
                    Button(action: clearAll) {
                        Text("Clear")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 200)
                            .frame(maxHeight: 45)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                    }
                    
                    NavigationLink(destination: SelectedItemsView(items: selectedItems)) {
                        Text("Selected Items")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 200)
                            .frame(maxHeight: 45)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                    }
                }
            }
            .navigationTitle("TRVoucher v3 🛸")
        }
    }
    
    private func clearAll() {
        for i in items_food.indices {
            items_food[i].quantity = 0
        }
        for i in items_drink.indices {
            items_drink[i].quantity = 0
        }
    }
}

struct SelectedItemsView: View {
    var items: [OrderItem]
    
    var body: some View {
        List {
            Section(header: Text("選択された料理")) {
                ForEach(items.filter { $0.name.contains("供養膳") || $0.name.contains("もも") || $0.name.contains("ゆり") || $0.name.contains("空") || $0.name.contains("風") || $0.name.contains("陽") || $0.name.contains("月") }) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("\(item.quantity) x \(item.price)円 = \(item.totalPrice)円")
                    }
                }
            }
            
            Section(header: Text("選択されたドリンク")) {
                ForEach(items.filter { !$0.name.contains("供養膳") && !$0.name.contains("もも") && !$0.name.contains("ゆり") && !$0.name.contains("空") && !$0.name.contains("風") && !$0.name.contains("陽") && !$0.name.contains("月") }) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("\(item.quantity) x \(item.price)円 = \(item.totalPrice)円")
                    }
                }
            }
        }
        .navigationTitle("Selected Items✅")
    }
}

struct OrderItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Int
    var quantity: Int = 0

    var totalPrice: Int {
        return price * quantity
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

