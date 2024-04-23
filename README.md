# Juice Shop Forged Signed JWT Challenge Auto Script

This repository contains an automated script designed to tackle the Juice Shop's "Forged Signed JWT Challenge". The script decodes a provided JWT token, modifies its header and payload as specified by the challenge, re-signs it using HMAC-SHA256, and then encodes the modified token for validation. It facilitates the process of understanding and completing the challenge within the OWASP Juice Shop web application by automating the necessary steps.

## Usage

To use the script, follow these steps:

1. Clone the repository to your local machine.
2. Run the `auto_forged.sh` script.
3. Paste the JWT token when prompted.
4. The script will decode the original token, modify its header and payload, re-sign it, and output the modified signed token.

## Requirements

- Bash shell environment
- OpenSSL
- curl

## Contribution

Contributions to enhance the functionality, documentation, or compatibility of the script are welcome! Feel free to submit pull requests or raise issues if you encounter any problems.

## License

This project is licensed under the [MIT License](LICENSE).
