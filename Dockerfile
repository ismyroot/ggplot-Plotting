# bulkRNA / 科研绘图「中量版」：在精简版基础上增加 ragg、plotly、PCA（factoextra）、KM 曲线（survminer）、网络图（ggraph/igraph）及常用辅助包。
# 仍不包含 paletteer、ggstatsplot、see 等（易拖入 Rmpfr / easystats 大依赖树）；需要时再手动加入 install 向量。
# Quay 等平台导出的构建日志 *.json 勿提交仓库。
#
# 构建示例：
#   docker build -t quay.io/1733295510/bulk-ggplot-plotting:medium .

FROM quay.io/1733295510/base-image:V1

LABEL maintainer="1733295510 <1733295510@qq.com>"
LABEL org.opencontainers.image.title="bulkRNA-ggplot-Plotting"
LABEL org.opencontainers.image.description="Medium ggplot2 stack: slim core + ragg, plotly, factoextra, survminer, ggraph/tidygraph/igraph, ggExtra, lemon, khroma, wesanderson (no paletteer/ggstatsplot)."

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

ARG R_INSTALL_NCPUS=4
ENV R_INSTALL_NCPUS=${R_INSTALL_NCPUS}

# cmake：fs/libuv；harfbuzz/fribidi：ragg/textshaping；glpk：igraph；其余：cairo、网络与 XML 等常见编译依赖。
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
      'ggridges', \
      'ggforce', \
      'ggtext', \
      'ggdist', \
      'ggbeeswarm', \
      'ggExtra', \
      'lemon', \
      'plotly', \
      'factoextra', \
      'survminer', \
      'ggraph', \
      'tidygraph', \
      'igraph', \
      'svglite', \
      'ragg'\
    ), repos = 'https://cloud.r-project.org', ask = FALSE, Ncpus = nc)" && \
    R -e "\
  suppressPackageStartupMessages({\
    library(ggplot2);\
    library(patchwork);\
    library(plotly);\
    library(ragg);\
    library(ggraph);\
    library(factoextra);\
    library(survminer);\
  });\
  cat('ggplot-Plotting medium OK: ggplot2', as.character(packageVersion('ggplot2')), \
      ' patchwork', as.character(packageVersion('patchwork')), '\n')\
"

WORKDIR /work
