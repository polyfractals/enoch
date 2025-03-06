# Use an official Jupyter Notebook base image that is Binder-ready.
FROM jupyter/base-notebook:latest

# Switch to root to install additional system packages.
USER root

# Install Clojure, Git, and curl.
RUN apt-get update && \
    apt-get install -y clojure git curl && \
    rm -rf /var/lib/apt/lists/*

# Install Leiningen (needed for building Cljupyter).
RUN curl -O https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
    chmod +x lein && \
    mv lein /usr/local/bin/ && \
    lein --version

# Increase Java heap memory to help with building the uberjar.
ENV JAVA_OPTS="-Xmx2g"

# Clone Cljupyter (shallow clone) and build its uberjar.
RUN git clone --depth=1 https://github.com/clojupyter/clojupyter.git /opt/clojupyter && \
    cd /opt/clojupyter && \
    lein uberjar

# (Optional) Copy your deps.edn if your project needs it.
COPY deps.edn /home/jovyan/

# Switch back to the notebook user.
USER $NB_UID

# Use the base image's startup script to launch Jupyter.
CMD ["start-notebook.sh"]
