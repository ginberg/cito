FROM rocker/rstudio:4.0.3

RUN apt-get update
RUN apt-get -y --no-install-recommends install \
    libcurl4-openssl-dev \
    libxml2-dev \
    libssl-dev \
    libxt6 \
    libz-dev \
    libpng-dev \
    libicu-dev \
    libpcre2-dev \
    liblzma-dev \
    libbz2-dev \
    libgdal-dev \
    libproj-dev \
    default-jdk \
    r-cran-rjava \
    pandoc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/

RUN mkdir -p /home/rstudio/cito
WORKDIR /home/rstudio/cito
RUN chown -R rstudio:rstudio /home/rstudio/cito
RUN chmod 755 /home/rstudio/cito
