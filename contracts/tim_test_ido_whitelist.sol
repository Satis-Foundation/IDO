// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    // function sendValue(address payable recipient, uint256 amount) internal {
        // require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        // (bool success, ) = recipient.call{ value: amount }("");
        // require(success, "Address: unable to send value, recipient may have reverted");
    // }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

/**
 * This is the smart contract for purchasing tokens on IDO.
 */

contract satisIDORemixWhitelist {

    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    address public owner;
    address public usdcAddressL1; // = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; // Ethereum L1 USDC address, edit if need.
    address public satisTokenAddress; // = 0x0000000000000000000000000000000000000000; // Ethereum L1 Satis token address, input need.
    IERC20 usdcToken; // = IERC20(usdcAddressL1);
    IERC20 satisToken; // = IERC20(satisTokenAddress);
    mapping (address => uint256) EOA_whiteList;
    mapping (address => uint256) clientBalance;
    mapping (address => uint256) collectTokenRecord; // 0 for not yet collected, 1 for collected already
    mapping (address => uint256) userWhiteList;
    uint256 totalUSDC = 0;
    uint256 totalClient = 0;
    uint256 totalSatisTokenSupply; // = 10000000000000000000000; // Total supply of Satis token to this contract, input need.
    uint256 startTime = 3000000000; // Unix timestamp in far far future
    uint256 endTime = 3000000001; // Unix timestamp in far far future
    uint256 auctionTime; // = 172800;
    uint256 minDepositValue;


    event changeOwnership(address newOwner);
    event depositInto(address senderAddress, uint depositValue);
    event withdrawOutFrom(address receiverAddress, uint withdrawValue);
    event collectSatisToken(address recerverAddress, uint obtainValue);
    event userWhiteListed(address[] whiteListedUsers);
    event userWhiteListRemoved(address[] removedUsers);

    modifier isOwner() {
        require (msg.sender == owner, "Not an admin");
        _;
    }

    modifier userIsWhiteListed() {
        require (userWhiteList[msg.sender] == 1, "You are not whitelisted yet");
        _;
    }

    modifier correctSignatureLength(bytes memory _targetSignature) {
        require (_targetSignature.length == 65, "Incorrect signature length");
        _;
    }
    
    modifier enoughMobileAssets (uint256 _withdrawValue) {
        require (clientBalance[msg.sender] >= _withdrawValue, "Not enough mobile assets for withdrawal");
        _;
    }

    modifier isDepositPeriod() {
        require ((block.timestamp >= startTime) && (block.timestamp <= endTime), "Not in deposit period");
        _;
    }

    modifier depositPeriodIsEnded() {
        require (block.timestamp >= endTime.add(1), "Deposit period not ended yet");
        _;
    }

    modifier ownShare() {
        require (clientBalance[msg.sender] > 0, "You do not own any share");
        _;
    }



    constructor(address _fakeUSDCAddress, address _fakeSatisTokenAddress, uint256 _totalSupplyFakeSatisToken, uint256 _startTime, uint256 _endTime) {
        owner = msg.sender;
        userWhiteList[owner] = 1;
        usdcAddressL1 = _fakeUSDCAddress;
        satisTokenAddress = _fakeSatisTokenAddress;
        usdcToken = IERC20(usdcAddressL1);
        satisToken = IERC20(satisTokenAddress);
        totalSatisTokenSupply = _totalSupplyFakeSatisToken;
        startTime = _startTime;
        endTime = _endTime;
        minDepositValue = 500 * 10 ** 6;
    }

    /**
     * @dev Transfer the ownership of this contract.
     */
    function transferOwnership(address _newOwner) public isOwner {
        owner = _newOwner;
        emit changeOwnership(owner);
    }

    /**
     * @dev Recover signature from client, used for EOA address check.
     */
    function recoverSignature(bytes32 _targetHash, bytes memory _targetSignature) public pure correctSignatureLength(_targetSignature) returns(address) {
        bytes32 _r;
        bytes32 _s;
        uint8 _v;

        require (_targetSignature.length == 65, "Length of signature must be 65");

        assembly {
            /*
            First 32 bytes stores the length of the signature

            add(sig, 32) = pointer of sig + 32
            effectively, skips first 32 bytes of signature

            mload(p) loads next 32 bytes starting at the memory address p into memory
            */

            // first 32 bytes, after the length prefix
            _r := mload(add(_targetSignature, 32))
            // second 32 bytes
            _s := mload(add(_targetSignature, 64))
            // final byte (first byte of the next 32 bytes)
            _v := and(mload(add(_targetSignature, 65)), 255)
            //_v := byte(0, mload(add(_targetSignature, 96)))
        }

        require (_v == 0 || _v == 1 || _v == 27 || _v == 28, "Recover v value is fundamentally wrong");

        if (_v < 27) {
            _v += 27;
        }

        require (_v == 27 || _v == 28, "Recover v value error: Not 27 or 28");

        return ecrecover(_targetHash, _v, _r, _s);
    }

    /**
     * @dev Trigger the start of IDO. End in 48 hrs (172800 secs). 
     */
    /*
    function startIDO() public isOwner {
        startTime = block.timestamp;
        endTime = startTime + auctionTime;
    }
    */

    /**
     * @dev Allow owner to add whitelisted users.
     */
    function addUserWhiteList(address[] memory _addAddressList) external isOwner {
        for(uint256 i=0; i < _addAddressList.length; i++) {
            userWhiteList[_addAddressList[i]] = 1;
        }
        emit userWhiteListed(_addAddressList);
    }

    /**
     * @dev Allow owner to remove whitelisted users.
     */
     /*
    function removeUserWhiteList(address[] memory _removeAddressList) external isOwner {
        for(uint256 i=0; i < _removeAddressList.length; i++) {
            userWhiteList[_removeAddressList[i]] = 0;
        }
        emit userWhiteListRemoved(_removeAddressList);
    }
    */

    /**
     * @dev Get estimated auction time left with block.timestamp, with UNIX timestamp.
     */
    function getAuctionTimeLeft() external view isDepositPeriod returns(uint256 _timeLeft) {
        if (block.timestamp >= endTime) {
            _timeLeft = 0;
        } else{
            _timeLeft = endTime.sub(block.timestamp);
        }
    }

    /**
     * @dev Get start time of the IDO auction, in UNIX timestamp.
     */
    function getStartTime() external view returns(uint256 _startTime) {
        _startTime = startTime;
    }

    /**
     * @dev Get end time of the IDO auciton, in UNIX timestamp.
     */
    function getEndTime() external view returns(uint256 _endTime) {
        _endTime = endTime;
    }

    /**
     * @dev Get estimated current time with block.timestamp, in UNIX timestamp.
     */
    function getCurrentTime() external view returns(uint256 _currentTime) {
        _currentTime = block.timestamp;
    }

    /**
     * @dev Clients deposit assets to IDO in auction period.
     */
    function depositAssets(uint256 _usdcValue, bytes32 _hashForRecover, bytes memory _targetSignature) external isDepositPeriod userIsWhiteListed {
        if (EOA_whiteList[msg.sender] != 1) {
            require (_usdcValue > minDepositValue, 'Minimum initial deposit value not matched');
            address _recoveredAddress;
            _recoveredAddress = recoverSignature(_hashForRecover, _targetSignature);
            require (_recoveredAddress == msg.sender, 'Not an EOA');
            EOA_whiteList[_recoveredAddress] = 1;
            totalClient += 1;
        }
        usdcToken.safeTransferFrom(msg.sender, address(this), _usdcValue);
        clientBalance[msg.sender] = clientBalance[msg.sender].add(_usdcValue);
        totalUSDC = totalUSDC.add(_usdcValue);
        emit depositInto(msg.sender, _usdcValue);
    }

    /**
     * @dev Clients withdraw assets from IDO, during auction period.
     */
     /*
    function withdrawAssets(uint256 _usdcValue) external isDepositPeriod userIsWhiteListed enoughMobileAssets(_usdcValue) {
        usdcToken.safeTransfer(msg.sender, _usdcValue);
        clientBalance[msg.sender] = clientBalance[msg.sender].sub(_usdcValue);
        totalUSDC = totalUSDC.sub(_usdcValue);
        emit withdrawOutFrom(msg.sender, _usdcValue);
    }
    */

    /**
     * @dev View personal deposited assets.
     */
    function viewPersonalAssets() view external returns(uint256 _personalUSDC) {
        _personalUSDC = clientBalance[msg.sender];
    }

    /**
     * @dev View total assets in this IDO (from all clients/bidder). 
     */
    function viewTotalAssetsInContract() view external returns(uint256 _totalUSDC) {
        _totalUSDC = totalUSDC;
    }

    /**
     * @dev View current worth price for Satis Token.
     */
    function viewCurrentSatisTokenPrice() view external returns(uint256 _currentPrice) {
        uint256 _depositToSupplyRatio = totalUSDC.mul(10 ** 18).div(totalSatisTokenSupply);
        if (_depositToSupplyRatio < 800) {
            _currentPrice = 800;
        } else {
            _currentPrice = _depositToSupplyRatio;
        }
    }

    /**
     * @dev View whitelisted address approved to join IDO.
     */
    function viewUserWhiteList(address _targetAddress) view external returns(uint256 _whiteListBoolean) {
        _whiteListBoolean = userWhiteList[_targetAddress];
    }

    /**
     * @dev View whitelisted address, verified as an EOA.
     */
    function viewEOAWhitelist(address _targetAddress) view external returns(uint256 _whiteListBoolean) {
        _whiteListBoolean = EOA_whiteList[_targetAddress];
    }

    /**
     * @dev  View total number of approved addresses.
     */
    function viewTotalEOAWhitelistedAddress() view external returns(uint256 _totalClient) {
        _totalClient = totalClient;
    }

    /**
     * @dev Clients collect tokens after auction period (only once per client, withdraw all available tokens).
     */
    function collectTokens() external depositPeriodIsEnded ownShare {
        require (collectTokenRecord[msg.sender] == 0, "User has collected his/her tokens");
        uint256 _collectValue;
        _collectValue = clientBalance[msg.sender].mul(totalSatisTokenSupply).div(totalUSDC);
        satisToken.safeTransfer(msg.sender,_collectValue);
        collectTokenRecord[msg.sender] = 1; // 0 --> not yet collected, 1 --> collected
        emit collectSatisToken(msg.sender,_collectValue);
    }

    /**
     * @dev View uncollected tokens share.
     */
    function viewUncollectedTokens() view external depositPeriodIsEnded ownShare returns(uint256 _uncollectedValue) {
        if (collectTokenRecord[msg.sender] == 1) {
            _uncollectedValue = 0;
        } else {
            _uncollectedValue = clientBalance[msg.sender].mul(totalSatisTokenSupply).div(totalUSDC);
        }
    }

    /**
     * @dev Allow owner to collect all the funds after auction.
     */
    function ownerCollectFund() public isOwner depositPeriodIsEnded {
        require (totalUSDC >= 0, "All assets have already been collected");
        usdcToken.safeTransfer(owner,totalUSDC);
        totalUSDC = 0;
    }

}