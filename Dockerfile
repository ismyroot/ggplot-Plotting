# bulkRNA / 通用科研绘图：ggplot2 及常用扩展生态（CRAN 主流插件合集）。
# 说明：CRAN 上依赖或扩展 ggplot2 的包数量很多，本镜像覆盖最常用的组合与期刊风主题/配色；
#       若需某个冷门包，可在本文件 install.packages 向量中追加包名后重建镜像。
#
# 基础镜像须已存在并可拉取（建议已含 R 与编译依赖，以便 ragg、igraph 等可正常安装）。
# 构建示例：
#   docker build -t quay.io/1733295510/bulk-ggplot-plotting:v1 .

FROM quay.io/1733295510/base-image:V1

LABEL maintainer="1733295510 <1733295510@qq.com>"
LABEL org.opencontainers.image.title="bulkRNA-ggplot-Plotting"
LABEL org.opencontainers.image.description="ggplot2 ecosystem: tidyverse, ggrepel, patchwork, plotly, ggraph, factoextra, survminer, ggstatsplot, palettes, export (svglite/ragg)."

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# 一次性安装：核心工作流 + 标注/拼图/主题/配色 + 统计与 specialty 图层 + 交互 + 网络 + 生存曲线 + 高质量栅格/SVG 导出
RUN R -e "install.packages(c(\
      'tidyverse', \
      'ggrepel', \
      'ggpubr', \
      'patchwork', \
      'cowplot', \
      'ggthemes', \
      'scales', \
      'viridis', \
      'RColorBrewer', \
      'colorspace', \
      'ggsci', \
      'khroma', \
      'wesanderson', \
      'paletteer', \
      'plotly', \
      'ggridges', \
      'ggforce', \
      'ggtext', \
      'ggdist', \
      'ggbeeswarm', \
      'ggExtra', \
      'lemon', \
      'see', \
      'ggraph', \
      'tidygraph', \
      'igraph', \
      'factoextra', \
      'survminer', \
      'ggstatsplot', \
      'svglite', \
      'ragg'\
    ), repos = 'https://cloud.r-project.org', ask = FALSE)" && \
    R -e "\
  suppressPackageStartupMessages({\
    library(ggplot2);\
    library(patchwork);\
    library(ggrepel);\
    library(plotly);\
    library(ggraph);\
    library(factoextra);\
    library(survminer);\
    library(ggstatsplot);\
    library(ragg);\
  });\
  cat('ggplot-Plotting OK: ggplot2', as.character(packageVersion('ggplot2')), \
      ' patchwork', as.character(packageVersion('patchwork')), '\n')\
"

WORKDIR /work
