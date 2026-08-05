// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @notice Registro imutável de hashes de eventos aceitos pelo servidor Pecuária.
/// @dev Nenhum dado operacional, identificador legível de animal ou dado pessoal
///      deve ser persistido neste contrato.
contract PecuariaIntegrityRegistry {
    struct IntegrityRecord {
        bytes32 payloadHash;
        uint64 registeredAt;
        address registeredBy;
    }

    error Unauthorized(address caller);
    error RecordAlreadyRegistered(bytes32 recordId);
    error InvalidRegistrar(address registrar);

    address public immutable OWNER;
    mapping(address registrar => bool authorized) public authorizedRegistrars;
    mapping(bytes32 recordId => IntegrityRecord record) private records;

    event RegistrarAuthorizationChanged(address indexed registrar, bool authorized);
    event IntegrityRecordRegistered(
        bytes32 indexed recordId, bytes32 indexed payloadHash, address indexed registeredBy, uint64 registeredAt
    );

    constructor(address initialRegistrar) {
        OWNER = msg.sender;
        _setRegistrar(initialRegistrar, true);
    }

    function setRegistrar(address registrar, bool authorized) external onlyOwner {
        _setRegistrar(registrar, authorized);
    }

    function register(bytes32 recordId, bytes32 payloadHash) external onlyRegistrar {
        if (isRegistered(recordId)) revert RecordAlreadyRegistered(recordId);

        uint64 registeredAt = uint64(block.timestamp);
        records[recordId] =
            IntegrityRecord({payloadHash: payloadHash, registeredAt: registeredAt, registeredBy: msg.sender});

        emit IntegrityRecordRegistered(recordId, payloadHash, msg.sender, registeredAt);
    }

    function isRegistered(bytes32 recordId) public view returns (bool) {
        return records[recordId].registeredAt != 0;
    }

    function getRecord(bytes32 recordId) external view returns (IntegrityRecord memory) {
        return records[recordId];
    }

    modifier onlyOwner() {
        if (msg.sender != OWNER) revert Unauthorized(msg.sender);
        _;
    }

    modifier onlyRegistrar() {
        if (!authorizedRegistrars[msg.sender]) revert Unauthorized(msg.sender);
        _;
    }

    function _setRegistrar(address registrar, bool authorized) private {
        if (registrar == address(0)) revert InvalidRegistrar(registrar);
        authorizedRegistrars[registrar] = authorized;
        emit RegistrarAuthorizationChanged(registrar, authorized);
    }
}
