# NCCU DS HW4 - PCA & CA Shiny App
# 林秋瑢 114753213
# 本機預覽：在 R console 執行 library(shiny); runApp("114753213")
# 參考 hw4 README example、ggbiplot 文件、FactoMineR 範例整合改寫

library(shiny)
library(bslib)
library(ggplot2)
library(ggbiplot)
library(FactoMineR)
library(factoextra)
library(DT)

# ============================================================
# UI
# ============================================================
ui <- navbarPage(
  title = "NCCU_DS2024_hw4_114753213",
  theme = bs_theme(bootswatch = "flatly"),

  # ---------- 首頁 ----------
  tabPanel("首頁",
    fluidRow(
      column(8, offset = 2,
        h2("Iris 資料集 - PCA & CA 互動分析"),
        tags$hr(),
        h4("姓名：林秋瑢"),
        h4("學號：114753213"),
        tags$hr(),
        h4("資料說明"),
        p("Iris（鳶尾花）資料集包含 150 筆觀測資料，分為三個物種各 50 筆：",
          tags$b("setosa"), "、", tags$b("versicolor"), "、", tags$b("virginica"), "。"),
        tags$ul(
          tags$li(tags$b("Sepal.Length"), " — 花萼長度 (cm)"),
          tags$li(tags$b("Sepal.Width"), " — 花萼寬度 (cm)"),
          tags$li(tags$b("Petal.Length"), " — 花瓣長度 (cm)"),
          tags$li(tags$b("Petal.Width"), " — 花瓣寬度 (cm)"),
          tags$li(tags$b("Species"), " — 物種")
        ),
        tags$hr(),
        h4("原始資料"),
        DTOutput("iris_table")
      )
    )
  ),

  # ---------- PCA 分析頁 ----------
  tabPanel("PCA 分析",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        h4("PCA 設定"),
        selectInput("pc_x", "X 軸主成分", choices = paste0("PC", 1:4), selected = "PC1"),
        selectInput("pc_y", "Y 軸主成分", choices = paste0("PC", 1:4), selected = "PC2"),
        tags$hr(),
        downloadButton("download_pca", "下載 PCA Scores (CSV)")
      ),
      mainPanel(
        width = 9,
        h4("PCA Biplot"),
        plotOutput("pca_biplot", height = "500px"),
        tags$hr(),
        fluidRow(
          column(6,
            h4("Scree Plot（變異解釋比例）"),
            plotOutput("scree_plot", height = "350px")
          ),
          column(6,
            h4("Loadings 表"),
            DTOutput("loadings_table")
          )
        )
      )
    )
  ),

  # ---------- CA 分析頁 ----------
  tabPanel("CA 分析",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        h4("CA 設定"),
        selectInput("ca_var", "分析變數",
          choices = c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"),
          selected = "Petal.Length"),
        sliderInput("ca_bins", "分組數 (bins)", min = 2, max = 5, value = 3, step = 1),
        tags$hr(),
        downloadButton("download_ca", "下載 CA Coordinates (CSV)")
      ),
      mainPanel(
        width = 9,
        h4("CA Biplot"),
        plotOutput("ca_biplot", height = "500px"),
        tags$hr(),
        fluidRow(
          column(6,
            h4("列聯表 (Contingency Table)"),
            DTOutput("contingency_table")
          ),
          column(6,
            h4("Chi-Square 檢定結果"),
            verbatimTextOutput("chisq_result")
          )
        )
      )
    )
  ),

  # ---------- About 頁 ----------
  tabPanel("About",
    fluidRow(
      column(8, offset = 2,
        h3("關於本應用程式"),
        p("本 Shiny App 為政大資料科學課程 HW4 作業，",
          "對 Iris 資料集進行 PCA（主成分分析）與 CA（對應分析）的互動式視覺化。"),
        tags$hr(),
        h4("使用技術"),
        tags$ul(
          tags$li("R Shiny + bslib（UI 框架與主題）"),
          tags$li("ggbiplot（PCA biplot）"),
          tags$li("FactoMineR + factoextra（CA 分析與視覺化）"),
          tags$li("DT（互動式表格）")
        ),
        h4("參考資料"),
        tags$ul(
          tags$li("hw4 README example（pca.R）"),
          tags$li("ggbiplot GitHub: vqv/ggbiplot"),
          tags$li("FactoMineR 官方文件")
        ),
        tags$hr(),
        p("林秋瑢 114753213 | NCCU DS 2026"),
        p("參考: hw4 README example, ggbiplot vignette, FactoMineR docs")
      )
    )
  )
)

# ============================================================
# Server
# ============================================================
server <- function(input, output, session) {

  # --- 首頁：iris 資料表 ---
  output$iris_table <- renderDT({
    datatable(iris, options = list(pageLength = 10, scrollX = TRUE),
              rownames = FALSE)
  })

  # --- PCA reactive：log transform + prcomp ---
  # 參考自 hw4 README example (pca.R)
  pca_result <- reactive({
    log.ir <- log(iris[, 1:4])
    ir.pca <- prcomp(log.ir, center = TRUE, scale. = TRUE)
    ir.pca
  })

  # --- PCA biplot ---
  output$pca_biplot <- renderPlot({
    ir.pca <- pca_result()
    # 取得使用者選擇的主成分編號
    pc_x <- as.integer(gsub("PC", "", input$pc_x))
    pc_y <- as.integer(gsub("PC", "", input$pc_y))

    # 避免選到相同的主成分
    validate(need(pc_x != pc_y, "請選擇兩個不同的主成分"))

    g <- ggbiplot(ir.pca,
                  obs.scale = 1, var.scale = 1,
                  groups = iris$Species,
                  choices = c(pc_x, pc_y),
                  ellipse = TRUE,
                  circle = FALSE)
    g <- g + scale_color_discrete(name = "Species")
    g <- g + theme_minimal()
    g <- g + theme(legend.direction = "horizontal", legend.position = "top",
                   text = element_text(size = 14))
    g
  })

  # --- Scree Plot（含累積變異曲線，加分功能）---
  output$scree_plot <- renderPlot({
    ir.pca <- pca_result()
    var_explained <- ir.pca$sdev^2 / sum(ir.pca$sdev^2) * 100
    cum_var <- cumsum(var_explained)

    df <- data.frame(
      PC = factor(paste0("PC", 1:4), levels = paste0("PC", 1:4)),
      Variance = var_explained,
      Cumulative = cum_var
    )

    ggplot(df, aes(x = PC)) +
      geom_col(aes(y = Variance), fill = "#2c3e50", alpha = 0.8, width = 0.6) +
      geom_line(aes(y = Cumulative, group = 1), color = "#e74c3c", linewidth = 1.2) +
      geom_point(aes(y = Cumulative), color = "#e74c3c", size = 3) +
      geom_text(aes(y = Variance, label = paste0(round(Variance, 1), "%")),
                vjust = -0.5, size = 4) +
      geom_text(aes(y = Cumulative, label = paste0(round(Cumulative, 1), "%")),
                vjust = -1, color = "#e74c3c", size = 3.5) +
      scale_y_continuous(limits = c(0, 105)) +
      labs(x = "Principal Component", y = "Variance Explained (%)") +
      theme_minimal() +
      theme(text = element_text(size = 13))
  })

  # --- Loadings 表 ---
  output$loadings_table <- renderDT({
    ir.pca <- pca_result()
    loadings_df <- as.data.frame(round(ir.pca$rotation, 4))
    loadings_df$Variable <- rownames(loadings_df)
    loadings_df <- loadings_df[, c("Variable", paste0("PC", 1:4))]
    datatable(loadings_df, rownames = FALSE,
              options = list(dom = "t", pageLength = 10))
  })

  # --- 下載 PCA Scores（加分功能）---
  output$download_pca <- downloadHandler(
    filename = function() { "pca_scores.csv" },
    content = function(file) {
      ir.pca <- pca_result()
      scores <- as.data.frame(ir.pca$x)
      scores$Species <- iris$Species
      write.csv(scores, file, row.names = FALSE)
    }
  )

  # --- CA reactive ---
  ca_result <- reactive({
    var_name <- input$ca_var
    n_bins <- input$ca_bins

    # 將連續變數離散化，參考 FactoMineR CA 範例
    bin_labels <- if (n_bins == 2) {
      c("Low", "High")
    } else if (n_bins == 3) {
      c("Low", "Medium", "High")
    } else if (n_bins == 4) {
      c("Low", "Med-Low", "Med-High", "High")
    } else {
      paste0("Bin", 1:n_bins)
    }

    binned <- cut(iris[[var_name]], breaks = n_bins, labels = bin_labels)
    cont_table <- table(binned, iris$Species)

    # FactoMineR CA 分析
    ca_obj <- CA(cont_table, graph = FALSE)

    list(
      cont_table = cont_table,
      ca_obj = ca_obj,
      var_name = var_name,
      binned = binned
    )
  })

  # --- CA biplot ---
  output$ca_biplot <- renderPlot({
    ca_res <- ca_result()
    fviz_ca_biplot(ca_res$ca_obj,
                   repel = TRUE,
                   col.row = "#2c3e50",
                   col.col = "#e74c3c",
                   title = paste("CA Biplot:", ca_res$var_name, "x Species")) +
      theme_minimal() +
      theme(text = element_text(size = 14))
  })

  # --- 列聯表 ---
  output$contingency_table <- renderDT({
    ca_res <- ca_result()
    ct <- as.data.frame.matrix(ca_res$cont_table)
    ct$Level <- rownames(ct)
    ct <- ct[, c("Level", colnames(as.data.frame.matrix(ca_res$cont_table)))]
    datatable(ct, rownames = FALSE, options = list(dom = "t"))
  })

  # --- Chi-Square 檢定 ---
  output$chisq_result <- renderPrint({
    ca_res <- ca_result()
    chisq.test(ca_res$cont_table)
  })

  # --- 下載 CA Coordinates（加分功能）---
  output$download_ca <- downloadHandler(
    filename = function() { "ca_coordinates.csv" },
    content = function(file) {
      ca_res <- ca_result()
      row_coords <- as.data.frame(ca_res$ca_obj$row$coord)
      col_coords <- as.data.frame(ca_res$ca_obj$col$coord)
      row_coords$Type <- "Row"
      col_coords$Type <- "Column"
      row_coords$Name <- rownames(row_coords)
      col_coords$Name <- rownames(col_coords)
      combined <- rbind(row_coords, col_coords)
      write.csv(combined, file, row.names = FALSE)
    }
  )
}

# ============================================================
# 啟動 App
# ============================================================
shinyApp(ui = ui, server = server)
