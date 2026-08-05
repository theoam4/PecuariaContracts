# Pecuaria Integrity Registry

Contrato Solidity para ancorar a integridade de eventos já aceitos pelo
servidor do sistema Pecuária. Ele armazena apenas `recordId`, `payloadHash`,
horário e carteira registradora; dados operacionais e dados pessoais permanecem
fora da blockchain.

O fluxo de produção é: SQLite local → API FastAPI → PostgreSQL/outbox → worker
→ este contrato. O aplicativo Flet nunca assina transações nem depende da rede
EVM.

## Deploy local

```shell
export INTEGRITY_REGISTRAR_ADDRESS=<endereco-do-worker>
forge script script/DeployPecuariaIntegrityRegistry.s.sol:DeployPecuariaIntegrityRegistry \
  --rpc-url http://127.0.0.1:8545 --broadcast --private-key <chave-de-desenvolvimento>
```

Após o deploy, use o endereço retornado e o ABI produzido por `forge build` nas
variáveis do worker Python. Nunca versione chaves privadas.

---

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/DeployPecuariaIntegrityRegistry.s.sol:DeployPecuariaIntegrityRegistry --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
