# Building

Building loki messenger binaries is done using github actions. Windows and linux binaries will build right out of the box but there are some extra steps needed for Mac OS

## Mac OS

The build script for Mac OS requires you to have a valid `Developer ID Application` certificate. Without this the build script cannot sign and notarize the mac binary which is needed for Catalina 10.15 and above.
If you would like to disable this then comment out `"afterSign": "build/notarize.js",` in package.json.

### Setup

Once you have your `Developer ID Application` you need to export it into a `.p12` file. Keep a note of the password used to encrypt this file as it will be needed later.

Encrypt the file using the following command, replacing `PASS` with a **SECURE PASSWORD**:

```
openssl enc -aes-256-cbc -salt -in certificate.p12 -out certificate.p12.enc -k PASS -md sha256
```

Once encrypted, move `certificate.p12.enc` into the build folder and commit the file into git.
**PLEASE ENSURE YOU DON'T COMMIT ANY OF THE PASSWORDS**

#### On GitHub:

1.  Navigate to the main page of the repository.
2.  Under your repository name, click **Settings**.
3.  In the left sidebar, click **Secrets**.
4.  Add the following secrets:
    1.  OpenSSL decryption
        * Name: `CERTIFICATE_DECRYPTION_PASSWORD`
        * Value: The password used to encrypt `p12` file to `.p12.enc`
    2.  Certificate password
        * Name: `CERTIFICATE_PASSWORD`
        * Value: The password that was set when the certificate was exported.
