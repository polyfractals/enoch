FROM jupyter/base-notebook:latest
USER root

RUN apt-get update && \
    apt-get install -y clojure git curl && \
    rm -rf /var/lib/apt/lists/*

# Install Leiningen
RUN curl -O https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
    chmod +x lein && \
    mv lein /usr/local/bin/ && \
    lein --version

# (Skip cloning and building Cljupyter)
# RUN git clone --depth=1 --branch main https://github.com/clojupyter/clojupyter.git /opt/clojupyter && \
#     cd /opt/clojupyter && \
#     lein uberjar

# Copy your Clojure source files or deps.edn if needed.
COPY deps.edn /home/jovyan/

USER $NB_UID
CMD ["start-notebook.sh"]
