// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.20;

// import "./Dominum.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

// contract DominumMiner is Ownable {
//     Dominum public domToken;
//     uint256 public constant TOTAL_SUPPLY = 15_000_000 * 10**18;
//     uint256 public constant MINT_PERIOD = 30 days;
//     uint256 public constant WITHDRAW_PERIOD = 1 days;
//     uint256 public constant BASE_MINTING_SPEED = 100;

//     uint256 public constant FIRST_MONTH_ALLOCATION = (TOTAL_SUPPLY * 40) / 100;
//     uint256 public constant SECOND_MONTH_ALLOCATION = (TOTAL_SUPPLY * 20) / 100;
//     uint256 public constant NEXT_FOUR_MONTHS_ALLOCATION = (TOTAL_SUPPLY * 15) / 100;
//     uint256 public constant FIRST_YEAR_ALLOCATION = (TOTAL_SUPPLY * 85) / 100;
//     uint256 public constant SECOND_YEAR_ALLOCATION = (TOTAL_SUPPLY * 10) / 100;
//     uint256 public constant THIRD_YEAR_ALLOCATION = (TOTAL_SUPPLY * 5) / 100;

//     uint256 public startTime;
//     uint256 public totalMined;
//     mapping(address => uint256) public lastMineTime;

//     event Mined(address indexed miner, uint256 amount);
//     event Withdrawn(address indexed miner, uint256 amount);
//     event MiningBoostUpdated(address indexed miner, uint256 newBoost);

//     constructor(address _domToken) {
//         domToken = Dominum(_domToken);
//         startTime = block.timestamp;
//     }

//     function mine() external {
//         require(block.timestamp >= lastMineTime[msg.sender] + MINT_PERIOD, "Wait before mining again");
//         require(totalMined < TOTAL_SUPPLY, "Max supply reached");

//         uint256 elapsedTime = block.timestamp - startTime;
//         uint256 baseReward = getReward(elapsedTime);
//         uint256 boost = miningBoosts[msg.sender] == 0 ? BASE_MINING_SPEED : miningBoosts[msg.sender];
//         uint256 reward = (baseReward * boost) / 100;

//         lastMineTime[msg.sender] = block.timestamp;
//         totalMined += reward;
//         pendingRewards[msg.sender] += reward;

//         emit Mined(msg.sender, reward);
//     }

//     function withdraw() external {
//         uint256 reward = pendingRewards[msg.sender];
//         require(reward > 0, "No reward to withdraw");

//         pendingRewards[msg.sender] = 0;
//         DOMToken.mint(msg.sender, reward);

//         emit Withdrawn(msg.sender, reward);
//     }

//     function getReward(uint256 elapsedTime) internal view returns (uint256) {
//         if (elapsedTime < MINT_PERIOD) {
//             return FIRST_MONTH_ALLOCATION / 30;
//         } else if (elapsedTime < 2 * MINT_PERIOD) {
//             return SECOND_MONTH_ALLOCATION / 30;
//         } else if (elapsedTime < 6 * MINT_PERIOD) {
//             return NEXT_FOUR_MONTHS_ALLOCATION / (4 * 30);
//         } else if (elapsedTime < 12 * MINT_PERIOD) {
//             return FIRST_YEAR_ALLOCATION / (6 * 30);
//         } else if (elapsedTime < 24 * MINT_PERIOD) {
//             return SECOND_YEAR_ALLOCATION / (12 * 30);
//         } else if (elapsedTime < 36 * MINT_PERIOD) {
//             return THIRD_YEAR_ALLOCATION / (24 * 30);
//         }
//         return 0;
//     }
// }
