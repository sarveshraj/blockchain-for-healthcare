# Blockchain for Healthcare: A Proof of Concept


## Installation

The projects requires NodeJS and npm to work. Instructions to install all other dependencies are given below.
> Note: The instructions given below are for Linux (specifically Ubuntu 18.04). You should be able to find similar instructions for MacOS and Windows. Although support is available for Windows, I recommend using Linux or MacOS. Windows has some difficulty playing with npm.

### Node modules

1. Move to the project directory and open it in your terminal.
2. Run `npm install`.

### Ganache

1. Go to [Ganache homepage](https://truffleframework.com/ganache) and download. 
2. If you are on Linux, you must have received an _.appimage_ file. Follow installation instructions available [here.](https://itsfoss.com/use-appimage-linux/)

### IPFS

1. Go to the [download page](https://docs.ipfs.io/introduction/install/) of IPFS and follow the instructions given.

### Local server

1. You can use any local server to deploy the web application.
2. I used PHP but feel free to choose anything of your liking.
3. To install PHP on your Linux machine, run `sudo apt-get install php`. Detailed instructions available [here.](https://thishosting.rocks/install-php-on-ubuntu/)
4. One more great option is lite-server which is available as a node module.
5. Install lite-server by running the following command on your terminal `npm install -g lite-server`

### Metamask

1. Metamask is a browser extension available for Google Chrome, Mozilla Firefox and Brave Browser.
2. Go to the this [link](http://metamask.io/) and add Metamask to your browser.

## Getting the dApp running

### Configuration

#### 1. Ganache
  - Open Ganache and click on settings in the top right corner.
  - Under **Server** tab:
    - Set Hostname to 127.0.0.1 -lo
    - Set Port Number to 8545
    - Enable Automine
  - Under **Accounts & Keys** tab:
    - Enable Autogenerate HD Mnemonic

#### 2. IPFS
  - Fire up your terminal and run `ipfs init`
  - Then run 
    ```
    ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin "['*']"
    ipfs config --json API.HTTPHeaders.Access-Control-Allow-Credentials "['true']"
    ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods "['PUT', 'POST', 'GET']"
    ```
#### 3. Metamask
  - As soon as you install Metamask, it will ask you to accept some terms and policies. Read them and accept.
  - It will then ask you to create an account, just 
  
### Deploying the contract

I purposely haven't used any development framework so as to keep the code as raw as possible. This will also be easier to understand for any newcomer who is already having a tough time understanding the many technologies the application is built on.

#### 1. Starting your local development blockchain
  - Open Ganache.
  - Make sure to configure it the way mentioned above.
  
Moving on, to deploy the contract on the blockchain you have two options:
  - Use any available development framework for dApps. I recommend the [Truffle](https://truffleframework.com/truffle) framework. [Embark](https://embark.status.im/) is another great alternative.
  - Go full on geek mode and deploy it yourself with a few lines of code.

I'll be explaining the second method here.

#### 2. Deploying the contract and linking it to the frontend
