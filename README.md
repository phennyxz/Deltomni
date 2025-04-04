# Deltomni
Sistema Criptográfico e Esteganográfico Personalizado


### **1. Visão Geral do Sistema**

O sistema proposto é uma solução criptográfica e esteganográfica que combina:
- **Criptografia personalizada** (usando cifras baseadas em tabuleiros dinâmicos).
- **Geração de senhas cíclicas** baseadas em sementes (`seed`).
- **Dissimulação em texto claro** para ocultar mensagens secretas.

O objetivo é criar um sistema seguro e discreto para comunicação secreta, onde:
- O conteúdo da mensagem é protegido por criptografia.
- O código cifrado é embutido em um texto sintético legítimo.
- A comunicação pode ser realizada por canais públicos sem levantar suspeitas.

---

### **2. Componentes do Sistema**

#### **a) DeltaOmni**
- **O Que É?**
  - DeltaOmni é o nome do algoritmo criptográfico usado no sistema.
  - Ele combina duas chaves (`key0` e `key1`) e um tabuleiro dinâmico (`tabb`) para cifrar e decifrar mensagens.
  - O algoritmo usa um mapa de saída (`map`) para codificar as coordenadas das letras no tabuleiro.

- **Papel no Sistema**
  - DeltaOmni é o núcleo do sistema, responsável por transformar o texto plano em código cifrado e vice-versa.
  - Ele garante que a mensagem seja protegida contra interceptação e análise externa.

---

#### **b) deltomni.sh**
- **O Que É?**
  - `deltomni.sh` é o script Bash que implementa o algoritmo DeltaOmni.
  - Ele é o componente principal do sistema, responsável por executar as operações de cifragem e decifragem.

- **Funcionalidades**
  - **Cifragem**: Transforma o texto plano em código cifrado usando `key0` e `key1`.
  - **Decifragem**: Recupera o texto plano a partir do código cifrado.
  - **Tabuleiro Dinâmico**: Atualiza o tabuleiro (`tabb`) durante o processo para aumentar a segurança.
  - **Permutação**: Troca posições de caracteres no tabuleiro para dificultar ataques.

- **Exemplo de Uso**
  ```bash
  ./deltomni.sh -k "CHAVE0" -K "CHAVE1" -c "MENSAGEM SECRETA"
  ```

---

#### **c) shelOTCod**
- **O Que É?**
  - `shelOTCod` é um script auxiliar que gera senhas cíclicas (`key0`) com base em uma semente inicial (`seed`).
  - Ele usa uma função hash (ex.: SHA-256) para derivar uma senha a partir da semente e de um timestamp ou intervalo de tempo.

- **Papel no Sistema**
  - `shelOTCod` é responsável por gerar dinamicamente a chave `key0`, que é usada pelo DeltaOmni.
  - A geração cíclica ou incremental (`key0`) permite que remetente e destinatário sincronizem suas chaves sem precisar armazená-las explicitamente.

- **Exemplo de Geração de `key0`**
  ```bash
  key0=$(bash shelOTCod.sh "seed_inicial")
  ```

---

#### **d) Dissimulação em Texto Claro**
- **O Que É?**
  - Após cifrar o texto plano, o código cifrado é embutido em um texto sintético legítimo.
  - Isso é feito aplicando uma **regra de colação** que define como o código cifrado será inserido no texto.

- **Papel no Sistema**
  - A dissimulação garante que o código cifrado passe despercebido, mesmo em canais públicos.
  - Exemplos de regras de colação:
    - Inserir o código como vogais alternadas entre palavras.
    - Codificar o código nas posições ou comprimentos de palavras.

---

### **3. Fluxo do Sistema**

Aqui está o fluxo completo do sistema:

1. **Configuração Inicial**
   - Distribua a semente (`seed`) e a chave fixa (`key1`) por um canal seguro.
   - Ambos os lados devem concordar previamente com o algoritmo DeltaOmni e as regras de colação.

2. **Geração de `key0`**
   - Use `shelOTCod` para gerar `key0` dinamicamente a partir da semente.
   - O intervalo de tempo ou ciclo pode ser ajustado conforme necessário.

3. **Cifragem**
   - Use `deltomni.sh` para cifrar o texto plano com `key0` e `key1`.
   - O resultado será um código cifrado compacto.

4. **Dissimulação**
   - Insira o código cifrado em um texto sintético legítimo usando uma regra de colação.
   - O texto sintético deve parecer natural e inofensivo.

5. **Distribuição**
   - Publique o texto sintético por um canal público (ex.: e-mail, redes sociais).

6. **Decifragem**
   - Extraia o código cifrado do texto sintético usando a mesma regra de colação.
   - Use `deltomni.sh` para decifrar o código cifrado com `key0` e `key1`.

---

### **4. Papel de Cada Componente**

| **Componente**     | **Função**                                                                 |
|---------------------|---------------------------------------------------------------------------|
| **DeltaOmni**       | Algoritmo criptográfico que cifra/decifra mensagens usando `key0` e `key1`. |
| **deltomni.sh**     | Implementação do DeltaOmni em Bash, responsável pelas operações principais. |
| **shelOTCod**       | Gerador de senhas cíclicas (`key0`) baseadas em semente (`seed`).           |
| **Regra de Colação**| Define como o código cifrado é embutido no texto sintético.                |

---

### **5. Exemplo Prático**

#### **Configuração Inicial**
- **Semente (`seed`)**: `senha_inicial_123`
- **Chave Fixa (`key1`)**: `BALEIAAZULVERDE`

#### **Geração de `key0`**
```bash
key0=$(bash shelOTCod.sh "senha_inicial_123")
```

#### **Cifragem**
```bash
code=$(bash deltomni.sh -k "$key0" -K "BALEIAAZULVERDE" -c "ISSO E UM TESTE")
```

Saída:
```
EO,AE,UE,EE,AU,AU,EE,EE,EU,AO,AE,AU
```

#### **Dissimulação**
Insira o código cifrado em um texto sintético:
```
Relatório de navegação: Observamos um cardumeEO,AE,UE ao sul do porto.
```

#### **Decifragem**
Extraia o código cifrado do texto sintético e decifre:
```bash
secret=$(bash deltomni.sh -k "$key0" -K "BALEIAAZULVERDE" -d "EO,AE,UE,EE,AU,AU,EE,EE,EU,AO,AE,AU")
```

Saída:
```
ISSOEUMTESTE
```

---

### **6. Considerações Finais**

- **Integração dos Componentes**:
  - `shelOTCod` e `deltomni.sh` trabalham juntos para garantir a segurança e discrição da comunicação.
  - A dissimulação em texto claro adiciona uma camada extra de sigilo.

- **Benefícios**:
  - **Segurança**: Combinação de criptografia robusta e dissimulação.
  - **Discrição**: O texto sintético parece completamente legítimo.
  - **Flexibilidade**: Pode ser adaptado para diferentes cenários e tipos de canais.

- **Desafios**:
  - Sincronização entre remetente e destinatário (especialmente para `key0`).
  - Qualidade do texto sintético (deve parecer natural).

Com essa estrutura, fica claro o papel de cada componente e como eles se integram para formar um sistema seguro e eficiente.
