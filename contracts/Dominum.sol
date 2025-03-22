// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Dominum is ERC20, Ownable {
    uint256 public constant TOTAL_SUPPLY = 15_000_000 * 10**18;
    uint256 public constant INFLATION_RATE = 100;
    uint256 public constant TAX_RATE = 10;

    address public immutable inflationWallet;
    address public immutable taxWallet;
    uint256 public lastMintTime;

    event TaxPaid(address indexed sender, uint256 amount);
    event InflationMinted(uint256 amount);

    constructor(address _inflationWallet, address _taxWallet) ERC20("Dominum", "DOM") {
        require(_inflationWallet != address(0), "Invalid inflation wallet");
        require(_taxWallet != address(0), "Invalid tax wallet");

        inflationWallet = _inflationWallet;
        taxWallet = _taxWallet;
        lastMintTime = block.timestamp;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= TOTAL_SUPPLY, "Max supply reached");
        _mint(to, amount);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 taxAmount = (amount * TAX_RATE) / 10000;
        uint256 sendAmount = amount - taxAmount;

        super.transfer(taxWallet, taxAmount);
        super.transfer(recipient, sendAmount);

        emit TaxPaid(msg.sender, taxAmount);
        return true;
    }

    function mintInflation() external onlyOwner {
        require(block.timestamp >= lastMintTime + 90 days, "Inflation mining only every 3 months");

        uint256 inflationAmount = (totalSupply() * INFLATION_RATE) / 10000;
        _mint(inflationWallet, inflationAmount);

        emit InflationMinted(inflationAmount);
        lastMintTime = block.timestamp;
    }

    function applyTax(address sender, address recipient, uint256 amount) external {
        uint256 taxAmount = (amount * TAX_RATE) / 10000;
        uint256 sendAmount = amount - taxAmount;

        super.transferFrom(sender, taxWallet, taxAmount);
        super.transferFrom(sender, recipient, sendAmount);

        emit TaxPaid(sender, taxAmount);
    }
}
