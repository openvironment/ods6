FROM trnv/trnv-verse

## Install packages from CRAN
ENV GITHUB_PAT "ebef42ed4c74419ba25b969568ee8095dc935127"
COPY ./ /tmp/app/
RUN R -e "install.packages('shiny', repos = 'http://cran.rstudio.com')"
RUN R -e "remotes::install_local('/tmp/app/', repos = 'http://cran.rstudio.com', upgrade = FALSE)"

## Copy folder
EXPOSE 80/tcp
RUN rm /srv/shiny-server/index.html
COPY . /srv/shiny-server/
COPY ./inst/shiny-server.conf /etc/shiny-server/shiny-server.conf
