library(tidyverse)

# 1. 读取并转换数据
NO <- read_csv("betaof3.csv", na = c("", "NA", "N/A")) %>% 
  rename(Treatment = ...1) %>% 
  mutate(across(-Treatment, ~ as.numeric(gsub("%", "", .)))) %>%
  mutate(across(-Treatment, ~ if_else(is.na(.), 0, .))) %>%
  mutate(Treatment = as.factor(Treatment))

# 2. 重塑数据
long_data <- NO %>%
  pivot_longer(
    cols = -Treatment,
    names_to = "type",
    values_to = "value"
  )

# 3. 修正类型名称
correct_order <- c("c", "f", "u", "d", "m", "k", "lO", "lA", "lI", "RO", "RI", "RLI", "RLO")

# 4. 创建显示标签列
long_data <- long_data %>%
  mutate(
    type = factor(type, levels = correct_order),
    type_display = factor(type, levels = correct_order)
  )

# 5. 完整的颜色方案
treatment_colors <- c(
  "Haibei+G+10%" = "#006D2C",
  "Haibei+G-10%" = "#74C476",
  "Haibei-G+10%" = "#08519C",
  "Haibei-G-10%" = "#6BAED6",
  "Pawnee-G+10%" = "#E38D26",
  "Pawnee-G-10%" = "#F1CC74"
)

# 6. 设置Treatment顺序
treatment_order <- c("Haibei+G+10%", "Haibei+G-10%", "Haibei-G+10%", 
                     "Haibei-G-10%", "Pawnee-G+10%", "Pawnee-G-10%")
long_data <- long_data %>%
  mutate(Treatment = factor(Treatment, levels = treatment_order))

# 7. 创建LaTeX风格的角标标签
latex_labels <- list(
  "c", "f", "u", "d", "m", "k",
  bquote(l[O]), bquote(l[A]), bquote(l[I]),
  bquote(R[O]), bquote(R[I]), bquote(R[LI]), bquote(R[LO])
)

# 8. 创建绘图 - 优化纵轴对齐和网格线
p1_custom <- ggplot(long_data, aes(x = type_display, y = value, fill = Treatment)) +
  # 添加参数间的虚线
  geom_vline(
    xintercept = seq(1.5, length(levels(long_data$type_display)) - 0.5, by = 1),
    linetype = "dashed",
    color = "gray50",
    linewidth = 0.3,
    alpha = 0.7
  ) +
  geom_col(
    position = position_dodge(width = 0.8), 
    width = 0.7,
    color = "black",
    linewidth = 0.3
  ) +
  coord_flip() +
  scale_y_continuous(
    limits = c(-25, 25), 
    breaks = c(-20, -10, 0, 10, 20),
    labels = scales::percent_format(scale = 1)
  ) +
  scale_x_discrete(
    labels = latex_labels
  ) +
  scale_fill_manual(
    values = treatment_colors,
    name = "Treatment"
  ) +
  labs(
    y = "Percentage change", 
    x = "Parameters",
    title = "Elasticity analysis"
  ) +
  theme_minimal() +
  theme(
    text = element_text(size = 12), 
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 14, face = "bold"),
    axis.title.y = element_text(margin = margin(r = 15)), # 增加y轴标题右边距
    axis.text = element_text(size = 12, color = "black"),
    axis.text.y = element_text(
      face = "bold", 
      hjust = 0, # 左对齐标签
      margin = margin(r = 10) # 增加右边距
    ),
    # 优化网格线 - 只保留垂直网格线（用于百分比标记）
    panel.grid.major.x = element_line(color = "gray90", linewidth = 0.2), # 垂直网格线
    panel.grid.major.y = element_blank(), # 移除水平网格线
    panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(color = "black"),
    legend.position = "right",
    legend.title = element_text(size = 12, face = "bold"),
    legend.text = element_text(size = 10),
    plot.margin = margin(20, 20, 20, 40) # 增加左边距，为标签腾出空间
  ) +
  geom_hline(yintercept = 0, color = "black", linewidth = 0.5)

# 9. 显示图形
print(p1_custom)

# 10. 保存为TIFF格式 (600 DPI)
ggsave(
  filename = "elasticity_analysis.tiff",  # 文件名
  plot = p1_custom,                      # 要保存的图形对象
  device = "tiff",                       # 输出格式
  dpi = 600,                             # 分辨率
  width = 10,                            # 宽度（英寸）
  height = 8,                            # 高度（英寸）
  units = "in",                          # 单位（英寸）
  compression = "lzw"                    # 压缩算法（无损压缩算法减小文件大小）
)
