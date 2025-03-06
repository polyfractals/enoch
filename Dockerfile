# Use an official Clojure image with OpenJDK 11
FROM clojure:openjdk-11

# Switch to root to install system packages
USER root

# Install required packages: git, curl, python3, and pip3
RUN apt-get update && \
    apt-get install -y git curl python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Install Jupyter Notebook via pip
RUN pip3 install notebook

# Install Leiningen (needed to build Cljupyter)
RUN curl -O https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
    chmod +x lein && \
    mv lein /usr/local/bin/ && \
    lein --version

# Clone Cljupyter and build its uberjar
RUN git clone https://github.com/clojupyter/clojupyter.git /opt/clojupyter && \
    cd /opt/clojupyter && \
    lein uberjar

# Set the working directory (Binder expects notebooks in /home/jovyan)
WORKDIR /home/jovyan

# (Optional) Copy your deps.edn if your project needs it
COPY deps.edn /home/jovyan/deps.edn

# Expose port 8888 for Jupyter
EXPOSE 8888

# Start Jupyter Notebook with no token/password and allow all origins.
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=", "--NotebookApp.password=", "--NotebookApp.allow_origin=*"]
