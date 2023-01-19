## <p align="center">config.install.sh :)
<p align="center">💻🐧 O principal objetivo desta ferramenta é automatizar a configuração do IPTABLES + SSH + FAIL2BAN + LOG no Linux.
<align="center"><br><br>
<img src="https://github.com/mmateuseduardo/Facilities/blob/main/config-security/img/01.PNG"/>
<img height="300" width="588"  src="https://github.com/mmateuseduardo/Facilities/blob/main/config-security/img/02.PNG"/>

## Sobre<br>
Este SCRIPT (Linux) está sendo desenvolvido com o objetivo de facilitar a configuração de SSH-IPTABLEs-FAIL2BAN com LOG.<br><br>

Observação: Parte das configuração aplicada estou retirando de projetos publicado na internet, como por exemplo o script de iptables foi desenvolvido e fornecido pelo blog do remonti. Segue abaixo os links caso queira utilizar somente a regras de iptables a parte.<br>
https://blog.remontti.com.br/2435<br>
https://blog.remontti.com.br/2478<br>
https://github.com/danielcshn/dude-install.sh

## ✅ Suporte<br> 
Debian 10 (Buster)<br>
Debian 11 (Bullseye) - Em Teste<br>
CentOS 07 - Em Test<br>

Observação: Todo o projeto foi desenvolvido em cima de shell, as informações de suporte acima somente afirma em qual ambiente efetuei diversos testes e os resultados foram **OK**.

## ⬇️ Installing
```bash
sudo apt install git
git clone https://github.com/mmateuseduardo/Facilities.git
cd /Facilities/config-security
chmod +x config.security.sh
./config.security.sh
```
## 🛠️ Tools - 2 MENU<br>
<h3>[1]</h3>
- Verifica Dependencias - Não Disponível.<br>
- Instala e Configura IPTABLES + SSH<br>
- Limpa as Configuração de IPTABLES
<h3>[2]</h3>
- Instala e Configura IPTABLES<br>
- Libera Protocolos do Tipo Publico TCP/UDP<br>
- Reset Configuração de SSH<br><br>
Observação: Dentro da pasta ssh contem um arquivo com o nome de Banner para apresentação quando for efetuado o login no ssh.<br>

## 🤝 Contribuindo<br>
No momento, aceitamos contribuições para este repositório.<br>
Siga os passos abaixo para contribuir com a ferramenta digital:<br>

- 1.Faça um repositório.<br>
- 2.Desenvolva a nova funcionalidade ou faça as alterações que você acha que agregam valor à ferramenta<br>
- 3.Faça um "pull request" documentando detalhadamente as alterações propostas no repositório.<br><br>
Se você não contribuiu para o repositório, mas achou a ferramenta útil, adoraríamos ouvir sobre sua experiência. Conte-nos sobre sua experiência em um problema.**<br><br>

Atribuições<br>
Informe-nos no "pull request" seu nome de usuário e organização para adicioná-lo à lista de contribuições no Readme.md.<br>

## 📧 Contato
Link do Projeto: https://github.com/mmateuseduardo/Facilities.git<br>
Link do Projeto: https://github.com/mmateuseduardo/Facilities/tree/main/config-security<br>

## 📝 Licença
```
Este projeto está sob a licença do MIT.

```
