# API 實作測驗

* Ruby version：3.3.0

* Rails version：7.1.3

* API URL
```
http://localhost:3000/api/orders
```

* Docker 啟動指令

build image
```
docker build --build-arg MASTER_KEY="$MASTER_KEY" -t solution_api_app .
```

run container
```
docker run -p 3000:3000 solution_api_app
```

## SOLID 原則

- **S**：每個類別在實現中只負責一項任務。`OrdersController` 處理 HTTP 請求，`OrderService` 處理驗證邏輯以及金額轉換。
- **O**：類別對擴展開放，但對修改封閉。例如，`OrderService` 可以通過新增驗證和轉換規則來擴展，而無需修改現有代碼。
- **L**：此原則在這個小例子中沒有明確使用。
- **I**：OrderService 提供了具體的介面 (`valid?` 和 `transform_currency`)，確保 class 只需實現它們使用的方法。
- **D**：`OrdersController` 依賴於抽象 (`OrderService`) 而非具體實現。

## 設計模式

- **服務對象模式**：驗證和轉換邏輯封裝在服務對象 (`OrderService`) 中，以促進關注點分離並提高可測試性。
