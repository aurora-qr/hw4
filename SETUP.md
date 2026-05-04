# SETUP - PCA & CA Shiny App (114753213)

## (A) 套件安裝

在 R console 或終端機執行以下指令安裝所有必要套件：

```r
install.packages(c("shiny", "ggplot2", "FactoMineR", "factoextra",
                    "DT", "bslib", "devtools"))
devtools::install_github("vqv/ggbiplot")
```

> 注意：`ggbiplot` 不在 CRAN，必須透過 `devtools::install_github()` 從 GitHub 安裝。
> 如果系統沒有 `devtools`，請先執行 `install.packages("devtools")`。

完整套件列表：
- shiny
- bslib
- ggplot2
- ggbiplot（GitHub: vqv/ggbiplot）
- FactoMineR
- factoextra
- DT
- devtools（僅安裝 ggbiplot 時需要）

## (B) 本機預覽

在 VS Code 終端機執行：

```bash
cd ~/Documents/NCCU_DS_hw4/hw4
Rscript -e 'shiny::runApp("114753213", launch.browser=TRUE)'
```

或在 R console 中：

```r
setwd("~/Documents/NCCU_DS_hw4/hw4")
library(shiny)
runApp("114753213")
```

App 預設會在 http://127.0.0.1:xxxx 開啟。

## (C) 部署到 shinyapps.io

1. 到 https://www.shinyapps.io 用 GitHub 帳號登入，設定 account name
2. 右上角頭像 → Tokens → Show → Copy to clipboard
3. 安裝 rsconnect：
   ```bash
   Rscript -e 'install.packages("rsconnect")'
   ```
4. 在 R console 中貼上從 shinyapps.io 複製的 `rsconnect::setAccountInfo(...)` 指令執行
5. 部署 App：
   ```bash
   cd ~/Documents/NCCU_DS_hw4/hw4
   Rscript -e 'rsconnect::deployApp("114753213", appName = "NCCU_DS2024_hw4_114753213")'
   ```
6. 部署完成後，把產生的網址填回 `README.md` 的 ShinyApps link 欄位

## (D) 推到 GitHub

```bash
cd ~/Documents/NCCU_DS_hw4/hw4
git add 114753213/ README.md SETUP.md
git commit -m "HW4: PCA & CA Shiny App - 114753213 林秋瑢"
git push
```
