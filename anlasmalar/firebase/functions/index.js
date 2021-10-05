const functions = require("firebase-functions");

exports.helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", { structuredData: true });
  response.send("Hello from Firebase!");
});

// 1. bildirimle 2. sayfaya push olma
// 2. Bulut İşlemleri kurulumu
// 3. web butonunu gösterme

// firebase functions kurulum adımları

/*
1. chocolatey kurulumu =>
  PowerShell'i yönetici olarak açıyoruz.
  https://chocolatey.org/install =>
  bu satırın devamını kopyalayıp PowerShell'e yapıştırıyoruz:
  - Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
2. nodejs kurulumu => bu satırın devamını kopyalayıp PowerShell'e yapıştırıyoruz:
  - choco install nodejs
3. firebase'i global olarak kurma => bu satırın devamını kopyalayıp PowerShell'e yapıştırıyoruz:
  - npm install -g firebase-tools
4. Bulut İşlemleriları oluşturuyoruz biz firebase isminde oluşturmuştuk.
  terminalden klasöre giderek ilk defa kullanıyorsak
  - firebase login
  sonrasında
  - firebase init
  Bulut İşlemleriları kullanacağımız projeyi seçiyoruz (exists projects seçeneği). sonrasında ok tuşları ile aşağı inip functions seçeneğini space tuşu ile işaretleyip enter'a basıyoruz.
  javascript seçip devam ediyoruz.

5. Bütün işlem kodlarını yazdıktan sonra işlemleri buluta göndermek için terminalde
  - firebase deploy
  Yazıp enter'a basıyoruz.
*/