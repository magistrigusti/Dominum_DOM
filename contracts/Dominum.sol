// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Dominum is ERC20, Ownable {
  uint256 public constant TOTAL_SUPPLY = 15_000_000 * 10**8;
  uint256 public constant INITIAL_SUPPLY = (TOTAL_SUPPLY * 10) / 100;
  uint256 public constant MINTABLE_SUPPLY = (TOTAL_SUPPLY * 9) / 100;
  uint256 public constant MINT_PERIOD = 90 days;
  uint256 public constant MINT_INSTALMENT = MINTABLE_SUPPLY / 12;
  uint256 public constant INFLATION_RATE = 25;

  address public immutable inflationWallet;
  address public immutable taxWallet;
  uint256 public lastMintTime;

  event TaxPaid(address indexed sender, uint256 amount);
  event TokensMinted(uint256 amount);
  event InflationMinted(uint256 amount);

  constructor(address _inflationWallet, address _taxWallet) ERC20("Dominum", "DOM") {
    require(_inflationwallet != address(0), "Invalid inflation wallet");
    require(_taxWallet != address(0), "Invalid tax wallet");

    inflationWallet = _inflationWallet;
    taxWallet = _taxWallet;

    _mint(msg.sender, INITIAL_SUPPLY);
    lastmintTime = lock.timestamp;
  }

  function mint() external onlyOwner {
    require(block.timestamp >= lastMintTime + MINT_PERIOD, "Too early to mint");

    if(totalSupply() < TOTAL_SUPPLY) {
      uint256 mintAmount = MINT_INSTALMENT;
      _mint(owner(), mintAmount);
      emit TokenMinted(mintAmount);
    }

    uint256 inflationAmount = (totalSupply() * INFLATION_RATE) / 10000;
    _mint(inflationWallet, inflationAmount);
    emit InflationMinted(inflationAmount);

    lastMintTime = block.timestamp;
  }

  function mintInflation() external onlyOwner {
        require(block.timestamp >= lastMintTime + 90 days, "Inflation mining only every 3 months");

        uint256 inflationAmount = (totalSupply() * INFLATION_RATE) / 10000;
        _mint(inflationWallet, inflationAmount);

        emit InflationMinted(inflationAmount);
        lastMintTime = block.timestamp;
  }

  function transfer(address recipient, uint256 amount) public override returns (bool) {
    require(amount > 0.01 * 10**8, "Amount must be greater than tax");

    uint256 taxAmount = 0.01 * 10**8;
    uint256 sendAmount = amount - taxAmount;

    super.transfer(taxWallet, taxAmount);
    super.transfer(recipient, sendAmount);

    emit TaxPaid(msg.sender, taxAmount);
    return true;
  }
}