# bulkRNA / 科研绘图「中量版」：在精简版基础上增加 ragg、plotly、PCA（factoextra）、KM 曲线（survminer）、网络图（ggraph/igraph）及常用辅助包。
# 仍不包含 paletteer、ggstatsplot、see 等（易拖入 Rmpfr / easystats 大依赖树）；需要时再手动加入 install 向量。
# 构建日志里若出现 “Package libuv was not found”：表示 R 包 fs 未检测到系统 libuv，会改用语内置 libuv；已安装 libuv1-dev 可优先走系统库、少告警。
# 若 JSON 在安装中途又出现 build-scheduled：多为单次 RUN 超时；已拆成两段 install.packages，并请调大平台构建时限。
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

# cmake：fs 内置 libuv 编译备用；libuv1-dev：让 fs 优先用系统 libuv；libnlopt-dev：nloptr（survminer/lme4 链）少本地 cmake 编 NLopt。
# harfbuzz/fribidi：ragg；glpk：igraph；其余：cairo、网络与 XML。
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
    libnlopt-dev \
    libpng-dev \
    libssl-dev \
    libtiff5-dev \
    libuv1-dev \
    libxml2-dev \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

# 第一段：ggplot 核心与常用扩展（相对轻）
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
      'lemon'\
    ), repos = 'https://cloud.r-project.org', ask = FALSE, Ncpus = nc)"

# 第二段：plotly / 生存 / 网络 / 导出（依赖多、耗时长，单独一层便于缓存与避免单次 RUN 超时）
RUN R -e "nc <- suppressWarnings(as.integer(Sys.getenv('R_INSTALL_NCPUS', '4'))); \
  nc <- if (is.na(nc) || nc < 1L) 1L else nc; \
  install.packages(c(\
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
