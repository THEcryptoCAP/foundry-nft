# Foundry NFT Projects

This repository contains two NFT projects built using Foundry: MoodNFT and BasicNFT. Both projects demonstrate different aspects of NFT development on the Ethereum blockchain.

## Projects Overview

### 1. MoodNFT
A dynamic NFT that can change its appearance based on the owner's mood. The NFT can switch between happy and sad states, with each state having its own unique SVG image.

**Features:**
- Dynamic mood switching (Happy/Sad)
- On-chain SVG images
- Owner-only mood flipping
- Base64 encoded metadata
- ERC721 standard compliance

**Technical Details:**
- Built on Solidity ^0.8.18
- Uses OpenZeppelin's ERC721 implementation
- Implements Base64 encoding for metadata
- Stores SVG images on-chain
- Uses mapping for mood state tracking

### 2. BasicNFT
A simple NFT implementation that demonstrates basic NFT functionality with IPFS-hosted metadata.

**Features:**
- IPFS-hosted metadata
- Simple minting functionality
- ERC721 standard compliance
- Basic metadata structure

**Technical Details:**
- Built on Solidity ^0.8.18
- Uses OpenZeppelin's ERC721 implementation
- IPFS integration for metadata storage
- Simple token counter implementation

## Project Structure

```
├── src/
│   ├── MoodNft.sol         # MoodNFT contract implementation
│   └── BasicNft.sol        # BasicNFT contract implementation
├── script/
│   ├── DeployMoodNft.s.sol # MoodNFT deployment script
│   ├── DeployBasicNft.s.sol# BasicNFT deployment script
│   └── Interactions.s.sol  # Interaction scripts for both NFTs
├── test/
│   ├── MoodNftTest.t.sol   # MoodNFT test suite
│   └── BasicNftTest.t.sol  # BasicNFT test suite
└── img/
    ├── happy.svg          # Happy mood SVG image
    └── sad.svg           # Sad mood SVG image
```

## Getting Started

### Prerequisites
- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd foundry-nft-f24
```

2. Install dependencies:
```bash
forge install
```

3. Build the project:
```bash
forge build
```

### Testing

Run the test suite:
```bash
forge test
```

### Deployment

The project includes deployment scripts for both NFTs. To deploy:

1. For MoodNFT:
```bash
forge script script/DeployMoodNft.s.sol:DeployMoodNft --rpc-url <your-rpc-url> --private-key <your-private-key> --broadcast
```

2. For BasicNFT:
```bash
forge script script/DeployBasicNft.s.sol:DeployBasicNft --rpc-url <your-rpc-url> --private-key <your-private-key> --broadcast
```

### Interaction Scripts

After deployment, you can interact with the contracts using the provided scripts:

1. Mint MoodNFT:
```bash
forge script script/Interactions.s.sol:MintMoodNft --rpc-url <your-rpc-url> --private-key <your-private-key> --broadcast
```

2. Flip Mood:
```bash
forge script script/Interactions.s.sol:FlipMoodNft --rpc-url <your-rpc-url> --private-key <your-private-key> --broadcast
```

3. Mint BasicNFT:
```bash
forge script script/Interactions.s.sol:MintBasicNft --rpc-url <your-rpc-url> --private-key <your-private-key> --broadcast
```

## Technical Implementation Details

### MoodNFT

The MoodNFT contract implements:
- Dynamic mood switching through the `flipMood` function
- Owner-only access control for mood changes
- On-chain SVG storage and rendering
- Base64 encoded metadata for compatibility with NFT marketplaces
- ERC721 standard compliance with custom metadata structure

### BasicNFT

The BasicNFT contract implements:
- Simple minting functionality
- IPFS-hosted metadata
- Basic ERC721 standard compliance
- Token counter for unique token IDs

## Testing

The project includes comprehensive test suites for both contracts:

- `MoodNftTest.t.sol`: Tests mood switching, minting, and metadata generation
- `BasicNftTest.t.sol`: Tests basic NFT functionality and metadata handling
- `DeployMoodNftTest.t.sol`: Tests deployment script functionality and SVG conversion

Run tests with:
```bash
forge test
```

### Test Files Technical Details

#### 1. MoodNftTest.t.sol
- Tests the core functionality of the MoodNFT contract
- Verifies mood switching mechanism
- Tests metadata generation and Base64 encoding
- Validates owner-only access control
- Checks SVG image URI handling
- Tests token minting functionality
- Verifies token counter increment

#### 2. BasicNftTest.t.sol
- Tests basic NFT functionality
- Verifies token minting with IPFS metadata
- Tests token name and symbol
- Validates token balance tracking
- Checks token ownership
- Tests metadata structure

#### 3. DeployMoodNftTest.t.sol
- Tests the deployment script functionality
- Verifies SVG to Image URI conversion
- Tests Base64 encoding of SVG images
- Validates constructor parameters
- Checks deployment transaction broadcasting

### Deployment Scripts Technical Details

#### 1. DeployMoodNft.s.sol
```solidity
contract DeployMoodNft is Script {
    function run() external returns(MoodNft) {
        // Reads SVG files from local storage
        string memory sadSvg = vm.readFile("./img/sad.svg");
        string memory happySvg = vm.readFile("./img/happy.svg");

        // Broadcasts deployment transaction
        vm.startBroadcast();
        MoodNft moodNft = new MoodNft(
            svgToImageURI(sadSvg),
            svgToImageURI(happySvg)
        );
        vm.stopBroadcast();
        return moodNft;
    }

    // Converts SVG to Base64 encoded Image URI
    function svgToImageURI(string memory svg) public pure returns (string memory) {
        string memory baseURL = "data:image/xml+svg;bytes64,";
        string memory svgBase64Encoded = base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }
}
```

#### 2. DeployBasicNft.s.sol
```solidity
contract DeployBasicNft is Script {
    function run() external returns(BasicNft) {
        // Broadcasts deployment transaction
        vm.startBroadcast();
        BasicNft basicNft = new BasicNft();
        vm.stopBroadcast();
        return basicNft;
    }
}
```

#### 3. Interactions.s.sol
```solidity
contract MintBasicNft is Script {
    string public constant PUG = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function run() external {
        // Gets most recently deployed contract address
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "BasicNft",
            block.chainid
        );
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNft(contractAddress).mintNft(PUG);
        vm.stopBroadcast();
    }
}
```

### Deployment Process Flow

1. **MoodNFT Deployment:**
   - Reads SVG files from local storage
   - Converts SVG to Base64 encoded Image URI
   - Deploys contract with encoded URIs
   - Broadcasts transaction to network

2. **BasicNFT Deployment:**
   - Deploys contract with default parameters
   - Broadcasts transaction to network

3. **Interaction Scripts:**
   - Retrieves most recently deployed contract address
   - Executes contract functions (mint, flip mood)
   - Broadcasts transactions to network

## License

This project is licensed under the MIT License - see the LICENSE file for details.
