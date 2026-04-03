# bulkRNA / 科研绘图「轻量版」：ggplot2 + tidy 核心与常用拼图/主题/配色/少量图层扩展 + SVG 导出（svglite）+ ggpubr（可能连带 car、broom 等统计作图依赖）。
# 仍不含 plotly、survminer、igraph、ragg、factoextra、ggtext/ggdist 等；需要时请自行追加包名。含 knitr、rmarkdown（与 base-image R 及 CRAN 一致）。
# libuv1-dev：减少 fs 装包时的 libuv 告警；Quay 构建超时请拆层或本地 build 后 push。
# Quay 等平台导出的构建日志 *.json 勿提交仓库。
#
# 构建示例：
#   docker build -t quay.io/1733295510/bulk-ggplot-plotting:light .

FROM quay.io/1733295510/base-image:V1

LABEL maintainer="1733295510 <1733295510@qq.com>"
LABEL org.opencontainers.image.title="bulkRNA-ggplot-Plotting"
LABEL org.opencontainers.image.description="Light ggplot2: core tidy + ggrepel, patchwork, cowplot, ggthemes, scales, viridis palettes, ggridges/ggforce, ggpubr, svglite, knitr, rmarkdown (no plotly/survminer/igraph/ragg)."

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

ARG R_INSTALL_NCPUS=4
ENV R_INSTALL_NCPUS=${R_INSTALL_NCPUS}

USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    cmake \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libjpeg-dev \
    libpng-dev \
    libssl-dev \
    libtiff5-dev \
    libuv1-dev \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

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
      'patchwork', \
      'cowplot', \
      'ggthemes', \
      'scales', \
      'viridis', \
      'RColorBrewer', \
      'colorspace', \
      'ggsci', \
      'ggpubr', \
      'ggridges', \
      'ggforce', \
      'svglite', \
      'knitr', \
      'rmarkdown'\
    ), repos = 'https://cloud.r-project.org', ask = FALSE, Ncpus = nc)" && \
    R -e "\
  suppressPackageStartupMessages({\
    library(ggplot2);\
    library(dplyr);\
    library(patchwork);\
    library(ggrepel);\
    library(ggpubr);\
    library(svglite);\
    library(knitr);\
    library(rmarkdown);\
  });\
  cat('ggplot-Plotting light OK: ggplot2', as.character(packageVersion('ggplot2')), \
      ' patchwork', as.character(packageVersion('patchwork')), \
      ' ggpubr', as.character(packageVersion('ggpubr')), \
      ' knitr', as.character(packageVersion('knitr')), \
      ' rmarkdown', as.character(packageVersion('rmarkdown')), '\n')\
"

WORKDIR /work
