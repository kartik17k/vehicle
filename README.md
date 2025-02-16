# 🚗 **Vehicle**  

This project handles all **vehicle-related operations** within the application. It provides functionalities to **manage vehicle data**, perform operations, and integrate with other modules.  

## ✨ **Features**  
✔️ **Vehicle Management** – Add and manage vehicle records.  

📡 **Data Integration** – Seamlessly integrate vehicle data with other modules.  

📊 **Performance Tracking** – Monitor and track vehicle performance metrics.  


## ⚙️ **Installation**  

### 1️⃣ **Clone the Repository**  
```bash
git clone https://github.com/kartik17k/vehicle.git
```

### 2️⃣ **Navigate to the Project Directory**  
```bash
cd vehicle
```

### 3️⃣ **Install Dependencies**  
```bash
flutter pub get
```

### 4️⃣ **Run the Application** 🚀  
```bash
flutter run
```


## How It Works   

### **1️⃣ Vehicle Input Form**  
- Users enter details:  
  - **Vehicle Name** (e.g., Toyota Corolla)  
  - **Year of Manufacture** (e.g., 2018)  
  - **Mileage (km/l)** (e.g., 18.5)  
- Input validation ensures:  
  - Vehicle name is not empty.  
  - Year is within a valid range (e.g., 1900–current year).  
  - Mileage is a positive number.  

---

### **2️⃣ Firebase Firestore Integration**  
- On submission, the vehicle details are **saved to Firestore** in a `vehicles` collection.  
- Firestore stores the data in real time and syncs across devices.  

---

### **3️⃣ Color Coding Logic (Efficiency & Pollution Levels)**  
Each vehicle is classified based on its **mileage** and **age**:  
- **🟢 Green** → Mileage ≥ 15 km/l AND Age ≤ 5 years (Fuel Efficient, Low Pollutant)  
- **🟠 Amber** → Mileage ≥ 15 km/l AND Age > 5 years (Fuel Efficient, Moderately Pollutant)  
- **🔴 Red** → Mileage < 15 km/l (Not Fuel Efficient, High Pollutant)  

This logic updates dynamically as vehicles are displayed.  

---

### **4️⃣ Real-Time Display & Updates**  
- Vehicles are fetched from Firestore and displayed in a **list view**.  
- The background color of each **vehicle card** is updated based on its classification.  
- **Live updates**: Any changes in Firestore automatically update the app UI.  



## **🚀 Summary**  
- **🔥 Firebase Firestore** stores vehicle data.  
- **🟡 Live updates** keep the app in sync.  
- **🎨 Dynamic color coding** for efficiency & pollution.   

This structure ensures an intuitive user experience with real-time updates! 🚗✨

For your **vehicle app**, here are the necessary **dependencies** to add to `pubspec.yaml`:  

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: latest_version
  cloud_firestore: latest_version
  firebase_auth: latest_version
  provider: latest_version
```



## **📌 Why These Dependencies?**  
 **`firebase_core` & `cloud_firestore`** → Integrates Firebase Firestore to store and retrieve vehicle data. 
 **`firebase_auth`** → Authentication.  
 **`provider`** → Manages state efficiently.  


## **🚀 Future Enhancements**  
✅ **Persistent Storage**  
   - Implement local storage (e.g., Hive, SharedPreferences) to cache vehicle data for offline access.  

✅ **Edit Functionality**  
   - Allow users to update vehicle details after submission.  

✅ **Light & Dark Mode Support**  
   - Implement theme switching for better user experience.  

This roadmap ensures continuous improvement and a **seamless user experience**! 🚗✨

---
### Contact
For questions or suggestions, feel free to reach out at:
- Email: kartikkattishettar@gmail.com
- GitHub: [Kartik](https://github.com/kartik17k)
