# Встановлюємо версії
ARG NGINX_VERSION=1.27.0
ARG NGX_CACHE_PURGE_VERSION=2.5.2

FROM nginx:${NGINX_VERSION} as builder

# Встановлення інструментів для збірки
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    git \
    libpcre3 \
    libpcre3-dev \
    zlib1g-dev \
    libssl-dev \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Оголошуємо змінну середовища
ENV NGX_CACHE_PURGE_VERSION=${NGX_CACHE_PURGE_VERSION}

# Завантаження вихідного коду Nginx
WORKDIR /tmp/build
RUN wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -xzf nginx-${NGINX_VERSION}.tar.gz

# Клонування модуля ngx_cache_purge з тегом 2.5.2
RUN git clone --depth 1 https://github.com/nginx-modules/ngx_cache_purge.git && \
    cd ngx_cache_purge && \
    git checkout ${NGX_CACHE_PURGE_VERSION}

# Збірка модуля ngx_cache_purge
WORKDIR /tmp/build/nginx-${NGINX_VERSION}
RUN ./configure --with-compat --add-dynamic-module=../ngx_cache_purge && \
    make modules

# Фінальний образ
FROM nginx:${NGINX_VERSION}

# Копіюємо зібраний модуль у фінальний образ
COPY --from=builder /tmp/build/nginx-${NGINX_VERSION}/objs/ngx_http_cache_purge_module.so /usr/lib/nginx/modules/

# Додаємо власний конфіг Nginx (з коректним `load_module`)
COPY nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]