# Use an official Jupyter Notebook base image that is Binder-ready.
FROM jupyter/base-notebook:python-3.9.16

# Switch to root to install additional system packages
USER root

# Install Clojure, Git, and curl.
RUN apt-get update && \
    apt-get install -y clojure git curl && \
    rm -rf /var/lib/apt/lists/*

# Install Leiningen (needed for building Cljupyter)
RUN curl -O https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
    chmod +x lein && \
    mv lein /usr/local/bin/ && \
    lein --version

# Clone Cljupyter and build its uberjar.
RUN git clone https://github.com/clojupyter/clojupyter.git /opt/clojupyter && \
    cd /opt/clojupyter && \
    lein uberjar

# (Optional) Copy your deps.edn if needed for your Clojure project.
COPY deps.edn /home/jovyan/

# Switch back to the notebook user.
USER $NB_UID

# The official base image’s CMD ("start-notebook.sh") will launch Jupyter Notebook properly.
CMD ["start-notebook.sh"]
