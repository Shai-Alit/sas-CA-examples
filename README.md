# SAS CA Examples

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![SAS Viya](https://img.shields.io/badge/SAS-Viya-1E90FF.svg)](https://www.sas.com/en_us/software/viya.html)
[![Python](https://img.shields.io/badge/Python-3.8%2B-blue.svg)](https://www.python.org)

**Collection of practical examples for working with SAS Viya, CAS Actions, Python integration, and SAS Studio Flows.**

## 📋 About

This repository contains code samples, Jupyter notebooks, SAS programs, and SAS Studio Flows demonstrating:

- **CAS Actions** and direct interaction with SAS Viya's Cloud Analytic Services
- **Python integration** using SWAT, saspy, and model management with PZMM
- **SAS Studio Flows** combining Python and SAS steps
- **Useful SAS macros** and procedures
- Model building, scoring, and deployment examples (e.g., XGBoost on baseball data)

Perfect for developers, data scientists, and SAS users exploring modern SAS Viya workflows.


## 📁 Repository Structure

```bash
sas-CA-examples/
├── Data/                          # Sample datasets used in examples
├── Flows/                         # SAS Studio Flow files
│   ├── python_plus_sas.flw
│   ├── python_plus_sas2.flw
│   └── py_program.py
├── SAS/
│   ├── Examples/                  # Individual SAS technique demos
│   │   ├── plotting_distributions/
│   │   ├── proc_http/
│   │   ├── proc_python/
│   │   ├── reliability_example_w_data/
│   │   └── transistor_demo_w_data/
│   └── useful_macros/             # Reusable SAS macros
├── python/
│   ├── build_XGB.py
│   ├── swat_example.py
│   ├── pzmm_example/              # Python Model Manager workflows
│   └── saspy_example/             # saspy integration examples
├── models/
│   └── baseball/                  # Pre-trained XGBoost model + artifacts
│       ├── XGBmodel.pickle
│       ├── scaler.pkl
│       └── encoder.pkl
├── _setup/                        # Connection scripts and environment setup
├── wb_startup/                    # SAS Workbench startup scripts
├── .gitignore
├── LICENSE
└── README.md
```

## 🚀 Quick Start

### Prerequisites
- SAS Viya environment (with CAS)
- Python 3.8+ with `swat`, `saspy`, `pandas`, `scikit-learn`, etc.
- SAS Studio (for Flows)

### Setup
```bash
git clone https://github.com/Shai-Alit/sas-CA-examples.git
cd sas-CA-examples
```


## 📖 Examples

### Python + SAS Viya

- **`swat_example.py`** — Direct CAS action calls using the SWAT package
- **`build_XGB.py`** — Building and saving an XGBoost model with preprocessing artifacts
- **`saspy_example/`** — Using `saspy` to run traditional SAS code from Python (includes config and quick start)
- **`pzmm_example/`** — Python Model Manager (PZMM) workflows for model registration and management

### SAS Studio Flows

- **`python_plus_sas.flw`** — SAS Studio Flow combining Python and SAS steps
- **`python_plus_sas2.flw`** — Additional mixed Python + SAS flow
- Supporting Python program: `py_program.py`

### SAS Code Examples

**SAS/Examples/** folder contains:

- **plotting_distributions** — Visualizing data distributions
- **proc_http** — Using PROC HTTP for API calls and web interactions (recently added)
- **proc_python** — Running Python code directly inside SAS via PROC PYTHON
- **reliability_example_w_data** — Reliability analysis example with sample data
- **transistor_demo_w_data** — Transistor reliability / survival analysis demo

### Useful Macros

**SAS/useful_macros/** — Reusable SAS macros for common tasks.

### Models

**`models/baseball/`**  
Pre-trained **XGBoost model** on baseball data, including:
- `XGBmodel.pickle` — Trained model
- `scaler.pkl` — Fitted scaler
- `encoder.pkl` — Fitted categorical encoder

Great for testing scoring pipelines and deployment examples.

### Setup & Utilities

- **`_setup/`** — Connection scripts and environment setup
- **`wb_startup/`** — SAS Workbench startup scripts
- **Data/** — Sample datasets used across examples

---

## 🛠️ Technologies Used

- **SAS Viya** & **CAS Actions**
- **Python** (SWAT, saspy, XGBoost, scikit-learn, pandas, PZMM)
- **SAS Studio Flows**
- **Jupyter Notebooks**
- **PROC PYTHON** & PROC HTTP

## 📜 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.


**Happy coding with SAS & Python!** 🎉

If you find these examples useful, please ⭐ the repository!
