// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title SIMPODExecutor - Core Execution Contract for SIMPOD Protocol
/// @author
/// @notice Executes and stores verified liquidation/arbitrage operations
/// @dev Modular, extensible, and designed for compatibility with off-chain logic

contract SIMPODExecutor {
    address public owner;

    struct Execution {
        address indexedBot;
        uint256 roiBasisPoints; // Return on investment (1% = 100 basis points)
        uint256 timestamp;
    }

    Execution[] private _executions;

    event ExecutionRegistered(address indexed bot, uint256 roiBasisPoints, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "SIMPOD: Unauthorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Registers an execution event manually (to be called by protocol controller)
    /// @param bot Address of the bot/operator who triggered the event
    /// @param roiBasisPoints Return on investment in basis points (100 = 1%)
    function registerExecution(address bot, uint256 roiBasisPoints) external onlyOwner {
        require(bot != address(0), "SIMPOD: Invalid bot address");
        require(roiBasisPoints <= 10000, "SIMPOD: ROI exceeds 100%");

        _executions.push(Execution({
            indexedBot: bot,
            roiBasisPoints: roiBasisPoints,
            timestamp: block.timestamp
        }));

        emit ExecutionRegistered(bot, roiBasisPoints, block.timestamp);
    }

    /// @notice Returns the number of executions stored
    function getExecutionCount() external view returns (uint256) {
        return _executions.length;
    }

    /// @notice Fetches a specific execution by index
    /// @param index Position in the array
    function getExecution(uint256 index) external view returns (address bot, uint256 roiBasisPoints, uint256 timestamp) {
        require(index < _executions.length, "SIMPOD: Index out of bounds");
        Execution memory exec = _executions[index];
        return (exec.indexedBot, exec.roiBasisPoints, exec.timestamp);
    }
}
