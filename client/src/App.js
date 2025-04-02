import logo from './logo.svg';
import './App.css';

import { useEffect, useState } from "react";
const ethers = require("ethers")
const abi=[
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "_tokenAddress",
        "type": "address"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "constructor"
  },
  {
    "inputs": [
      {
        "internalType": "string",
        "name": "_sellerName",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "_location",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "_harvestName",
        "type": "string"
      },
      {
        "internalType": "uint256",
        "name": "_quantity",
        "type": "uint256"
      }
    ],
    "name": "add_farmer",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "_harvestId",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "_quantity",
        "type": "uint256"
      }
    ],
    "name": "buyHarvest",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "string",
        "name": "_harvestName",
        "type": "string"
      }
    ],
    "name": "get",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "_harvestId",
        "type": "uint256"
      }
    ],
    "name": "getSellerAddress",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "id",
        "type": "uint256"
      },
      {
        "internalType": "string",
        "name": "_name",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "_quality",
        "type": "string"
      }
    ],
    "name": "give_quality_report",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "_address",
        "type": "address"
      }
    ],
    "name": "give_role_intermediary",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "_address",
        "type": "address"
      }
    ],
    "name": "give_role_quality",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "name": "harvests",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "id",
        "type": "uint256"
      },
      {
        "internalType": "address",
        "name": "seller",
        "type": "address"
      },
      {
        "internalType": "string",
        "name": "sellerName",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "location",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "harvestName",
        "type": "string"
      },
      {
        "internalType": "uint256",
        "name": "time",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "quantity",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "buyValue",
        "type": "uint256"
      },
      {
        "internalType": "string",
        "name": "qualitycheck_name",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "qualitycheck_result",
        "type": "string"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "liquidp",
    "outputs": [
      {
        "internalType": "contract LiquidityPool",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "nextId",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "owner",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "price",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "_harvestId",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "_quantity",
        "type": "uint256"
      }
    ],
    "name": "sellharvest",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "token",
    "outputs": [
      {
        "internalType": "contract IERC20",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  }
]
const contractAddress = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";

function App() {
  const [isWalletInstalled, setIsWalletInstalled] = useState(false);
  const [account, setAccount] = useState(null);
  const [contract, setContract] = useState(null);

  useEffect(() => {
    if (window.ethereum) {
      setIsWalletInstalled(true);
      const provider = new ethers.BrowserProvider(window.ethereum);
      const signer = provider.getSigner();
      const contractInstance = new ethers.Contract(contractAddress, abi, signer);
      setContract(contractInstance);
    }
  }, []);

  async function connectWallet() {
    try {
      const accounts = await window.ethereum.request({ method: "eth_requestAccounts" });
      setAccount(accounts[0]);
    } catch (error) {
      alert("Wallet connection failed");
    }
  }

  async function addFarmer(sellerName, location, harvestName, quantity) {
    if (!contract) return;
    try {
      const tx = await contract.add_farmer(sellerName, location, harvestName, quantity);
      await tx.wait();
      alert("Farmer added successfully");
    } catch (error) {
      console.error("Error adding farmer:", error);
    }
  }

  async function buyHarvest(harvestId, quantity) {
    if (!contract) return;
    try {
      const tx = await contract.buyHarvest(harvestId, quantity);
      await tx.wait();
      alert("Harvest bought successfully");
    } catch (error) {
      console.error("Error buying harvest:", error);
    }
  }

  async function getSellerAddress(harvestId) {
    if (!contract) return;
    try {
      const sellerAddress = await contract.getSellerAddress(harvestId);
      alert(`Seller Address: ${sellerAddress}`);
    } catch (error) {
      console.error("Error fetching seller address:", error);
    }
  }

  return (
    <div className="App">
      {account ? (
        <div>
          <p>Connected as: {account}</p>
          <button onClick={() => addFarmer("John Doe", "Texas", "Corn", 100)}>Add Farmer</button>
          <button onClick={() => buyHarvest(0, 10)}>Buy Harvest</button>
          <button onClick={() => getSellerAddress(0)}>Get Seller Address</button>
        </div>
      ) : (
        isWalletInstalled ? <button onClick={connectWallet}>Connect Wallet</button> : <p>Install Metamask</p>
      )}
    </div>
  );
}

export default App;
