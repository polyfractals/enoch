# Use an official Clojure image with OpenJDK 11
FROM clojure:openjdk-11

# Install required system packages: git and curl
RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

# Install Leiningen (needed to build Cljupyter)
RUN curl -O https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
    chmod +x lein && \
    mv lein /usr/local/bin/ && \
    lein --version

# Clone Cljupyter and build its uberjar
RUN git clone https://github.com/clojupyter/clojupyter.git /opt/clojupyter && \
    cd /opt/clojupyter && \
    lein uberjar

# Set the working directory for Jupyter
WORKDIR /home/jovyan

# (Optional) Copy your deps.edn if needed by your project
COPY deps.edn /home/jovyan/deps.edn

# Expose port 8888 (default for Jupyter)
EXPOSE 8888

# Default command (Binder will take over to start Jupyter)
CMD ["bash"]
