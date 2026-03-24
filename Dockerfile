# bulkRNA / 通用科研绘图：ggplot2 及常用 CRAN 扩展（元包不用 tidyverse，避免无关依赖链）。
# 说明：包很多，可按需在 install.packages 向量中增删；Quay 等平台导出的构建日志 *.json 仅作排障，勿提交仓库。
#
# 基础镜像须含 R 与基本编译工具链（gcc/g++/make 等）。
# 构建示例：
#   docker build -t quay.io/1733295510/bulk-ggplot-plotting:v1 .

FROM quay.io/1733295510/base-image:V1

LABEL maintainer="1733295510 <1733295510@qq.com>"
LABEL org.opencontainers.image.title="bulkRNA-ggplot-Plotting"
LABEL org.opencontainers.image.description="ggplot2 ecosystem: core tidy packages (no tidyverse meta), ggrepel, patchwork, plotly, ggraph, factoextra, survminer, ggstatsplot, palettes, svglite/ragg."

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# 构建时可选：docker build --build-arg R_INSTALL_NCPUS=8 .
ARG R_INSTALL_NCPUS=4
ENV R_INSTALL_NCPUS=${R_INSTALL_NCPUS}

# cmake：fs/libuv；harfbuzz/freetype 等：ragg、textshaping；glpk：igraph；curl/ssl/xml2：plotly/httr 等常见传递依赖；cairo：部分图形后端。
# 非 Debian/Ubuntu 请换等价包名。
USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    cmake \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libfribidi-dev \
    libglpk-dev \
    libharfbuzz-dev \
    libjpeg-dev \
    libpng-dev \
    libssl-dev \
    libtiff5-dev \
    libxml2-dev \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

# Ncpus：并行编译源码包，缩短构建时间（可按构建机核数调整）。
RUN R -e "nc <- suppressWarnings(as.integer(Sys.getenv('R_INSTALL_NCPUS', '4'))); \
  nc <- if (is.na(nc) || nc < 1L) 1L else nc; \
  install.packages(c(\
      'ggplot2', \
      'tibble', \
      'tidyr', \
      'readr', \
      'purrr', \
      'dplyr', \
      'stringr', \
      'forcats', \
      'lubridate', \
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
    ), repos = 'https://cloud.r-project.org', ask = FALSE, Ncpus = nc)" && \
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
