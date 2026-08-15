# Foundry Workflow — Guia Rápido

## 1. Setup Inicial

### Carregar variáveis de ambiente
```bash
set -o allexport; source .env; set +o allexport
```

### Importar carteira para Cast (primeira vez)
```bash
cast wallet import minhaCarteiraDeTeste --interactive
```
- Digite a chave privada (será solicitado interativamente).
- A carteira será armazenada em `~/.foundry/keystores/`.
- Use `--keystore-dir` para caminho customizado.

### Listar carteiras importadas
```bash
cast wallet list
```

---

## 2. Desenvolvimento & Testes

### Compilar contratos
```bash
forge build
```

### Rodar testes unitários
```bash
forge test
```

### Rodar testes com verbosidade (log detalhado)
```bash
forge test -vvvv
```

### Rodar teste específico
```bash
forge test --match-test testNomeFunction -vvvv
```

### Gerar relatório de cobertura (coverage)
```bash
forge coverage
```

### Executar um script localmente (sem broadcast)
```bash
forge script script/Deploy.s.sol
```

---

## 3. Deploy Local (Anvil)

### Iniciar nó local Anvil
```bash
anvil
```
- Endpoint padrão: `http://127.0.0.1:8545`
- Acesso padrão: 10 contas teste com 10,000 ETH cada.

### Deploy em Anvil (sem broadcast/apenas simulação)
```bash
forge script script/Deploy.s.sol --rpc-url http://127.0.0.1:8545
#testar com --rpc-url anvil ao invés da url inteira
```

### Deploy em Anvil (com broadcast/transação real)
```bash
forge script script/Deploy.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --private-key 0xAC0974BEC39A17E36BA4A6B4D238FF944BACB476C3BDDFB0FE5548ADA7D97FD8
#testar com --rpc-url anvil ao invés da url inteira
```

---

## 4. Deploy em Testnets Reais (search for RPC endpoints in foundry.toml)

### Sepolia (Ethereum Testnet)
```bash
forge script script/Deploy.s.sol --rpc-url sepolia --broadcast --account minhaCarteiraDeTeste -vvvv
```

### Optimism Sepolia
```bash
forge script script/Deploy.s.sol --rpc-url optimism_sepolia --broadcast --account minhaCarteiraDeTeste -vvvv
```

**Notas:**
- `--account minhaCarteiraDeTeste` usa a carteira importada via `cast wallet import`.
- `--broadcast` executa a transação (sem flag = apenas simulação).
- `-vvvv` mostra logs detalhados (hashes de tx, address de contrato, etc.).

---

## 5. Verificação em Explorers

### Verificar contrato no Etherscan (pós-deploy)
```bash
forge verify-contract <CONTRACT_ADDRESS> src/MyContract.sol:MyContract --chain sepolia --constructor-args $(cast abi-encode "constructor(string)" "initialValue")
```

### Usar Etherscan API Key
```bash
export ETHERSCAN_API_KEY="sua-chave-aqui"
forge verify-contract <CONTRACT_ADDRESS> src/MyContract.sol:MyContract --chain sepolia
```

---

## 6. Interações com Cast (Queries & Sends)

### Consultar saldo de endereço
```bash
cast balance 0x1234567890123456789012345678901234567890 --rpc-url sepolia
```

### Chamar função (read-only)
```bash
cast call 0xContractAddress "balanceOf(address)(uint256)" 0xWalletAddress --rpc-url sepolia
```

### Enviar transação (estado mutável)
```bash
cast send 0xContractAddress "transfer(address,uint256)" 0xToAddress 1000000000000000000 --rpc-url sepolia --account minhaCarteiraDeTeste
```

### Obter nonce (para construir tx manual)
```bash
cast nonce 0xWalletAddress --rpc-url sepolia
```

---

## 7. Debugging & Troubleshooting

### Simular transação (sem executar)
```bash
forge script script/Deploy.s.sol --rpc-url sepolia --account minhaCarteiraDeTeste
```

### Ver último hash de tx (em broadcast real)
```bash
cat broadcast/Deploy.s.sol/11155111/run-latest.json | grep transactionHash
```

### Limpar artefatos build
```bash
forge clean
```

---

## 8. Checklist Pré-Deploy

- [ ] Carregar `.env`: `set -o allexport; source .env; set +o allexport`
- [ ] Rodar testes: `forge test -vvvv`
- [ ] Formatar código: `forge fmt`
- [ ] Compilar: `forge build`
- [ ] Simular em testnet: `forge script script/Deploy.s.sol --rpc-url sepolia`
- [ ] Verificar private key está em `~/.foundry/keystores/`
- [ ] Deploy com `--broadcast` e `--account`
- [ ] Salvar address do contrato deployado
- [ ] Verificar no explorer (Etherscan, etc.)

---

## 9. Referência Rápida de Flags

| Flag | Descrição |
|------|-----------|
| `--rpc-url <name>` | Usa endpoint do foundry.toml (ex: `sepolia`) |
| `--broadcast` | Executa transação real (sem flag = simulação) |
| `--account <name>` | Usa carteira importada via `cast wallet import` |
| `--private-key <key>` | Usa chave privada direta (cuidado!) |
| `-vvvv` | Máxima verbosidade (logs detalhados) |
| `--verify` | Verifica contrato após deploy (requer ETHERSCAN_API_KEY) |
| `--skip-simulation` | Pula simulação e envia tx direto (raro) |

---

## 10. Segurança & Boas Práticas

- **Nunca** commite `.env` ou private keys.
- **Sempre** simule antes de fazer broadcast real.
- Use carteiras diferentes para teste vs produção.
- Teste em Anvil local **antes** de testnet.
- Verifique contrato no explorer após deploy.
- Revogue/rotacione API keys periodicamente.