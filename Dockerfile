# Use an official Clojure image (this one does not guarantee Leiningen is installed)
FROM clojure:openjdk-11

# Install system dependencies: git and curl are needed.
RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

# Install Leiningen manually
RUN curl -O https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
    chmod +x lein && \
    mv lein /usr/local/bin/ && \
    lein --version

# Clone clojupyter and build its uberjar
RUN git clone https://github.com/clojupyter/clojupyter.git /opt/clojupyter && \
    cd /opt/clojupyter && \
    lein uberjar

# Set working directory for Jupyter
WORKDIR /home/jovyan

# Copy your deps.edn (if needed)
COPY deps.edn /home/jovyan/deps.edn

# Expose the default port
EXPOSE 8888

# Default command; Binder will start Jupyter
CMD ["bash"]
