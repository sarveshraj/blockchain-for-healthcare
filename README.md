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
  - After installing Metamask, click on the metamask icon on your browser.
  - Click on __TRY IT NOW__, if there is an announcement saying a new version of Metamask is available.
  - Click on continue and accept all the terms and conditions after reading them.
  - Stop when Metamask asks you to create a new password. We will come back to this after deploying the contract in the next section.
  
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
  - Fire up your terminal and move to the project directory
  - Now open up `/YOUR_PROJECT_DIRECTORY/src/js/run.js` in your favourite text editor
  - You have to make two changes:
    1. Make sure the address in line number 3 is the same as your RPC server address on Ganache.
    If you have configured Ganache as instructed above, the code should look like this:
    
    ```
    var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
    ```
    2. The path in this line should point to where your solidity contract is located:
    
    ```
    var code = fs.readFileSync('/YOUR_PROJECT_DIRECTORY/contracts/Agent.sol').toString();
    ```
  - Go back to your terminal, type `node` and hit enter
  - Copy and paste all the contents of `run.js` to the terminal
  - If all goes well, you should see some few lines as output of the command
    ```
    console.log(compiledCode.contracts[':Agent'].interface);
    ```
  - This is the ABI of the contract, copy and paste these lines in line number 10 of `app.js`. The code should look like:
    ``` 
    abi = JSON.parse('PASTE_YOUR_ABI_HERE')
    ```
  - Go back to the terminal and type `deployedContract.address;`, which is also the last command of your `run.js` file. The     output is the address where the contract is deployed on the blockchain.
  - Copy the output and paste it on line number 13 of `app.js`. The code should look like:
    ```
    contractInstance = AgentContract.at('PASTE_YOUR_ADDRESS_HERE');
    ```
  - That's it for this part. Now lets set up Metamask.
  
### Running the dApp

#### 1. Connecting Metamask to our local blockchain
  - Let's go back to the configuration section of Metamask.
  - If done correctly, you would have stopped at the part where Metamask asks you to create a new password.
  - Just below the __CREATE__ button, click on the __Import with seed phrase__.
  - A form should open up, asking you to enter __Wallet Seed__.
  - Open Ganache, copy the twelve words that make up the __MNEMONIC__ on the __ACCOUNTS__ tab. 
  - Paste the twelve words in __Wallet Seed__. Create a new password and click __IMPORT__.
  
#### 2. Start a local server
  - Open a new terminal window and navigate to `/YOUR_PROJECT_DIRECTORY/src/`.
  - Run `php -S locahost:3000`.
  - Open `localhost:3000/register.html` on your browser.
  - That's it! The dApp is up and running locally.
