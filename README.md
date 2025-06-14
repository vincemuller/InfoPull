# 📐 InfoPull

**InfoPull** is a macOS application that enables users to upload images of technical drawings (e.g., engineering blueprints or architectural plans), extract structured metadata from key title block areas using trained OCR models, and export that data to a CSV for further use.

This tool is ideal for engineers, CAD technicians, and project managers who need to automate the process of pulling attributes like drawing numbers, titles, and project names from thousands of technical documents.

---

## ✨ Features

- 📤 **Batch File Uploading** — Select multiple `.jpg` or `.png` drawing files at once  
- 🤖 **AI-Powered OCR Extraction** — Uses trained models to extract:  
  - Drawing Number  
  - Drawing Title  
  - Project Name
  - Revision number/letter
- 📝 **Quick QA Interface** — Inline editing of extracted values for easy verification  
- 📷 **Image Preview** — See a cropped section of the drawing that was used for each extracted attribute  
- 📁 **Export to CSV** — One-click CSV export of your QA’d data  

---

## 📸 Workflow

1. **Select Drawings** — Upload one or many digital technical drawings.  
2. **Run Extraction** — Use AI to detect and extract structured metadata.  
3. **Review & Edit** — Validate and clean up extracted info.  
4. **Export** — Save the results to a CSV file for use in CAD systems, project databases, or reports.  

---

## 🧠 How It Works

InfoPull uses a trained **CoreML + Vision** model to locate the title block area of technical drawings. From there, it performs **OCR extraction** on predefined zones to collect structured metadata fields such as:

- Drawing Number  
- Drawing Title  
- Project Name
- Revision

Each result is paired with a cropped preview of the detected region, and users can manually review and edit extracted text inline.

All extracted data is stored locally and can be exported as a `.csv` for integration with external systems.

(The models in this repo are trained specifically for the dataset that lives in the "testingData" folder.  Specific models would need to be trained and added to the application for each unique drawing template/titleblock)

---

## 🧰 Tech Stack

- Swift + SwiftUI  
- CoreML + Vision  
- AppKit for image and file handling  
- macOS FileImporter API  
- CSV export logic  

---

## 🛣️ Roadmap

- 🧠 Ability to upload your own models  
- 🔀 Automatic model selection based on drawing layout  
- 🧹 Enhanced image pre-processing (deskewing, denoising)  
- 📚 Persistent storage with CoreData  
- 🗂️ Expanded file type support  
- ✏️ Additional tools for editing datasets

---

## 🚀 Getting Started

### Requirements

- macOS 13.0+  
- Apple Silicon (M1/M2/M3) or Intel Mac  
- Xcode 15+  

### Clone the Repo

```bash
git clone https://github.com/vincemuller/InfoPull.git
cd InfoPull

### 🛠 Build & Run

1. Open `InfoPull.xcodeproj` in Xcode  
2. Select the `My Mac` target  
3. Hit ⌘R to build and run the app

> ⚠️ When prompted, allow file system access so the app can read drawing files.

---

## 👨‍💻 Author

Built by [Vince Muller](https://github.com/vincemuller)  
Follow along as I build iOS/macOS tools and share what I learn.
