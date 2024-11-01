# GitHub Setup Wizard 🚀

An interactive command-line tool that streamlines the setup of SSH authentication with GitHub and the configuration of Go private modules. This wizard offers step-by-step guidance with an intuitive interface, making the setup process both enjoyable and foolproof. Originally developed by Slap Inc. and now available as open-source software.

![GitHub Setup Wizard](/screenshots/wizard_main.png)

## ✨ Features

- **Interactive SSH Setup**
  - Automatic SSH key generation
  - OS-specific clipboard integration
  - Secure key permissions configuration
  - SSH agent setup
  - GitHub connection testing

- **Go Private Modules Configuration**
  - Multiple authentication methods:
    - SSH (recommended)
    - Personal Access Token
    - GitHub CLI
  - Automatic `GOPRIVATE` environment setup
  - Shell configuration management
  - Connection testing

- **Cross-Platform Support**
  - 🪟 Windows
  - 🍎 macOS
  - 🐧 Linux

- **User-Friendly Interface**
  - ASCII art logo
  - Progress spinners
  - Color-coded output
  - Clear section headers
  - Interactive prompts

## 🚀 Quick Start

1. **Clone the repository:**
   ```bash
   git clone https://github.com/slapinc/github-setup-wizard.git
   ```
2. **Navigate to the project directory:**
   ```bash
   cd github-setup-wizard
   ```
3. **Make the script executable:**
   ```bash
   chmod +x setup_wizard.sh
   ```
4. **Run the wizard:**
   ```bash
   ./setup_wizard.sh
   ```

## 📋 Requirements

- **Bash shell**
- **Git**
- **SSH client**
- **Go** (for private modules setup)
- **GitHub CLI** (optional)

> **Note:** For Windows users, Git Bash or Windows Subsystem for Linux (WSL) is required.

## 🔧 OS-Specific Dependencies

### Windows

- **Git Bash** or **WSL**
- **PowerShell** (for certain features)

### macOS

- **Command Line Tools**
  - Install via:
    ```bash
    xcode-select --install
    ```

### Linux

- **xclip** or **xsel** (for clipboard support)
  - Install via:
    ```bash
    sudo apt-get install xclip   # For Debian-based systems
    sudo yum install xsel        # For Red Hat-based systems
    ```

## 🤝 Contributing

We welcome contributions from the community! Here's how you can contribute:

1. **Fork the repository**
2. **Create a feature branch:**
   ```bash
   git checkout -b feature/YourFeatureName
   ```
3. **Commit your changes:**
   ```bash
   git commit -m 'Add YourFeatureName'
   ```
4. **Push to your branch:**
   ```bash
   git push origin feature/YourFeatureName
   ```
5. **Open a Pull Request**

Please ensure your PR description clearly describes the changes and their benefits. We appreciate contributions in:

- Bug fixes
- Feature enhancements
- Documentation updates
- UI/UX improvements

## 🌟 About

The GitHub Setup Wizard was originally developed by Slap Inc. to simplify the complex process of setting up secure GitHub authentication and Go private module configuration. Now open-sourced, it provides a user-friendly interface with clear instructions and automated setup procedures, making it accessible to both beginners and experienced developers.

### Key Benefits

- **Eliminates common setup mistakes**
- **Saves time with automated configuration**
- **Provides clear visual feedback**
- **Supports multiple authentication methods**
- **Handles OS-specific requirements automatically**

## 📄 License

This project is licensed under the [MIT License](LICENSE).

## 📞 Support

If you encounter any issues or have suggestions:

1. **Check the [Issues](https://github.com/slapinc/github-setup-wizard/issues) page**
2. **Create a new issue** if your problem isn't already listed
3. **Provide detailed information** about your environment and the problem