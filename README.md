# Swag Labs Mobile Automation

## 🛠 Prerequisites

1. **Node.js** (latest LTS)
2. **Appium** 
   ```bash
   npm install -g appium
   ```
3. **Android SDK** → Set `ANDROID_HOME` environment variable
4. **UiAutomator2 driver**
   ```bash
   appium driver install uiautomator2
   ```

### ✅ Verify Setup
```bash
appium --version
```

## 🚀 Repository Setup

### 1. Install Python Requirements
```bash
pip install -r requirements.txt
```

### 2. Configure Environment (`.env`)
Copy `.env_template` → `.env` and update:
```
UDID=emulator-5554  # From `adb devices`
APP_PATH=app/your-app.apk
```

### 3. Configure App (`config.ini`)
Copy `config_template.ini` → `configs/config.ini`

**Required JSON files:**
```
configs/devices/android_emulator.json     # Device caps
configs/app/cap/swag_labs_v2_7_1.json     # App caps
```

**`.env` overrides `config.ini` priority**

### 4. PyCharm: Set Working Directory
```
Working directory → Project Root (contains .env, configs/, tests/)
```

## ▶️ Run Tests

### Terminal
```bash
# Start Appium (if not started AppiumServerManager does it for you)
appium 

# All tests
robot -v SMOKE_TEST:True -d .report tests/*/*.robot

# Smoke tests only
robot -i SMOKE_TEST tests/smoke/*.robot
```

### PyCharm Run Config
```
Parameters: -d .report tests/*/*.robot
```

## 📊 Reports
Generated in `.report/`:
- `log.html` - Detailed execution log
- `report.html` - Test summary

## 🎯 Features
- ✅ Full checkout flow automation
- ✅ Dynamic product selection  
- ✅ Faker-generated checkout data
- ✅ Robust scrolling (`Swipe Down Until Visible`)
- ✅ Config-driven (`.env` > JSON > `config.ini`)

## ▶️ Test execution example
   ![Swipe demo](/artifacts/demo.gif)
